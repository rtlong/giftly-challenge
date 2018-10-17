class BusinessLandingPagesController < ApplicationController
  def show
    id = params.fetch(:id)
    business = YelpBusiness.load(id)
    @business = YelpBusinessPresenter.new(business)

    @breadcrumbs_nav = [
      NavigationElement.new('Gift Cards', nil),
      NavigationElement.new(@business.city, nil),
    ]
    @business.primary_category.ancestry.first.each do |category|
      @breadcrumbs_nav << NavigationElement.new(category.title, nil)
    end
    @breadcrumbs_nav << NavigationElement.new(@business.name, nil)

    @similar_categories_nav = similar_categories_for(@business)

    @page_title = "#{@business.name} Gift Cards"
  end

  def similar_categories_for(business)
    categories = []

    business.categories_with_ancestors.map do |cat|
      cat = YelpCategoryPresenter.new(cat)
      text = "#{cat.display_title} in #{business.city}"
      url = "https://www.giftly.com/#{cat.id}-gift-cards/#{business.city.downcase.gsub(/[^a-z0-9]+/, '-')}-#{business.state.downcase}"
      categories << NavigationElement.new(text, url)
    end

    categories
  end
end
