require 'test_helper'

class MetasTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "title when visiting categories path with en locale" do
    visit "/categories?locale=en"
    assert_title "Categories"
  end

  test "title when visiting categories path with french locale" do
    visit "/categories?locale=fr"
    assert_title "Catégories"
  end

  test "title when visiting dynamic slug with en locale" do
    visit "/awesome-page?locale=en"
    assert_title "Really awesome"
  end

  test "title when visiting dynamic slug with french locale" do
    visit "/awesome-page?locale=fr"
    assert_title "Super page"
  end

  test "title when browsing a path with a / at the end" do
    visit "/categories/?locale=fr"
    assert_title "Catégories"
  end

  test "title when editing a category path in en" do
    visit edit_category_path(categories(:phone), locale: 'en')
    assert_title "Edit this category"
  end

  test "description when visiting categories path without locale" do
    visit "/categories?locale=en"
    assert_selector("meta[name='description'][content='List of categories']", visible: false)
  end

  test "description when visiting categories path with french locale" do
    visit "/categories?locale=fr"
    assert_selector("meta[name='description'][content='Liste des catégories']", visible: false)
  end

  test "every meta in locale file is present in the DOM" do
    visit "/categories?locale=en"
    assert_selector("meta[name='keywords'][content='categories, test']", visible: false)
  end

  test "use default metas if none match and default has been set" do
    visit "/without-metas?locale=de"
    assert_title "Standardtitel"
  end

  test "title should be empty if none match and default has not been set" do
    visit "/without-metas?locale=fr"
    assert_title ""
  end

  test "dynamic title should be set" do
    visit post_path(posts(:phone))
    assert_title "Phone article"
  end

  test "dynamic og title should be set" do
    visit post_path(posts(:phone))
    assert_selector("meta[property='og:title'][content='Phone article']", visible: false)
  end

  test "dynamic content works with many controller filter (metaslug_vars)" do
    visit edit_post_path(posts(:phone))
    assert_title "Edit Phone article"
  end

  test "doesn't interpolate when metas metaslug_vars are not set in the controller" do
    visit category_path(categories(:phone))
    assert_title "Category {{category.title}}"
  end

  test "title for dynamic page with slug containing dash" do
    visit "/another-page"
    assert_title "Yet another page"
  end
end
