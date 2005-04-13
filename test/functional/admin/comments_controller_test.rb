require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/comments_controller'

# Re-raise errors caught by the controller.
class Admin::CommentsController; def rescue_action(e) raise e end; end

class Admin::CommentsControllerTest < Test::Unit::TestCase
  fixtures :comments

  def setup
    @controller = Admin::CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_rendered_file 'list'
  end

  def test_list
    get :list
    assert_rendered_file 'list'
    assert_template_has 'comments'
  end

  def test_show
    get :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'comment'
    assert_valid_record 'comment'
  end

  def test_new
    get :new
    assert_rendered_file 'new'
    assert_template_has 'comment'
  end

  def test_create
    num_comments = Comment.find_all.size

    post :new, 'comment' => { }
    assert_redirected_to :action => 'show'

    assert_equal num_comments + 1, Comment.find_all.size
  end

  def test_edit
    get :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'comment'
    assert_valid_record 'comment'
  end

  def test_update
    post :edit, 'id' => 1
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Comment.find(1)

    get :destroy, 'id' => 1
    assert_success
    
    post :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      comment = Comment.find(1)
    }
  end
end
