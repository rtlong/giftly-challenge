class YelpCategory < YelpBaseModel
  def initialize(yelp_alias)
    @id = yelp_alias
  end

  attr_reader :id

  def title
    api_details.fetch('title')
  end

  def parent_ids
    api_details.fetch('parent_aliases')
  end

  def parents
    parent_ids.map { |pid| self.class.load(pid) }
  end

  def ancestry
    return [[self]] if parents.none?
    parents.map { |parent|
      parent.ancestry.flat_map { |anc| anc << self }
    }
  end

  def ancestors
    return [] if parents.none?
    parents.flat_map { |parent|
      parent.ancestors << parent
    }
  end

  def api_details
    @api_details ||= cache_fetch do
      self.class.yelp_client.category(id).fetch('category')
    end
  end

  def preload
    api_details
    parents
  end

  def self.precache_all
    yelp_client.all_categories.fetch('categories').each do |category|
      id = category.fetch('alias')
      Rails.cache.write(cache_key(id), category, expires_in: CACHE_EXPIRATION)
    end
  end

  def self.category_tree
    cats = precache_all
    # cats_by_alias = cats.reduce({}) { |h, cat| h[cat['alias']] = cat; h }

    tree = Hash.new { |h, k| h[k]=[] }
    cats.each do |cat|
      parents = cat['parent_aliases']
      if parents.none?
        parents = [:root]
      end

      parents.each do |pid|
        tree[pid] << tree[cat['alias']]
      end
    end

    tree
  end
end


class Tree
  def initialize(name)
    @name = name
    @children = []
  end

  def add_child(child)
    children[child['alias']] << child
  end

  def children
    @children ||= []
  end
end
