require 'test_helper'

class MetaslugHelperTest < ActionView::TestCase
  include Metaslug::ActionViewExtension

  test "should return title" do
    @metaslug = { 'title' => 'Foo' }
    assert_equal "<title>Foo</title>", metaslug
  end

  test "should return description" do
    @metaslug = { 'description' => 'Foo' }
    assert_equal "<meta name=\"description\" content=\"Foo\">", metaslug
  end

  test "should return opengraph title" do
    @metaslug = { 'og' => { 'title' => 'Foo' } }
    assert_equal "<meta property=\"og:title\" content=\"Foo\">", metaslug
  end

  test "should return deep metas" do
    @metaslug = { 'og' => { 'locale' => { 'alternate' => 'fr_FR' } } }
    assert_equal "<meta property=\"og:locale:alternate\" content=\"fr_FR\">", metaslug
  end
end
