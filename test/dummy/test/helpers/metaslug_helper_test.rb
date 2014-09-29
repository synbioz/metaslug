require 'test_helper'

class MetaslugHelperTest < ActionView::TestCase
  include Metaslug::ActionViewExtension

  test "should return title" do
    @metaslug = { 'title' => 'Foo' }
    assert_equal "<title>Foo</title>", metaslug
  end

  test "should return description" do
    @metaslug = { 'description' => 'Foo' }
    assert_equal "<meta content=\"Foo\" name=\"description\"></meta>", metaslug
  end

  test "should return opengraph title" do
    @metaslug = { 'og' => { 'title' => 'Foo' } }
    assert_equal "<meta content=\"Foo\" property=\"og:title\"></meta>", metaslug
  end

  test "should return deep metas" do
    @metaslug = { 'og' => { 'locale' => { 'alternate' => 'fr_FR' } } }
    assert_equal "<meta content=\"fr_FR\" property=\"og:locale:alternate\"></meta>", metaslug
  end
end
