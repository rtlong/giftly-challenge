class YelpCategoryPresenter < SimpleDelegator
  def display_title
    if has_parent?('restaurants')
      return title + ' restaurants'
    end

    title
  end

  private

  def has_parent?(cat_alias)
    parent_ids.include?(cat_alias)
  end
end
