require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe ViewComponentsController do

  def mock_view_component(stubs={})
    @mock_view_component ||= mock_model(ViewComponent, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all view_components as @view_components" do
      ViewComponent.stub(:all) { [mock_view_component] }
      get :index
      assigns(:view_components).should eq([mock_view_component])
    end
  end

  describe "GET show" do
    it "assigns the requested view_component as @view_component" do
      ViewComponent.stub(:find).with("37") { mock_view_component }
      get :show, :id => "37"
      assigns(:view_component).should be(mock_view_component)
    end
  end

  describe "GET new" do
    it "assigns a new view_component as @view_component" do
      ViewComponent.stub(:new) { mock_view_component }
      get :new
      assigns(:view_component).should be(mock_view_component)
    end
  end

  describe "GET edit" do
    it "assigns the requested view_component as @view_component" do
      ViewComponent.stub(:find).with("37") { mock_view_component }
      get :edit, :id => "37"
      assigns(:view_component).should be(mock_view_component)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created view_component as @view_component" do
        ViewComponent.stub(:new).with({'these' => 'params'}) { mock_view_component(:save => true) }
        post :create, :view_component => {'these' => 'params'}
        assigns(:view_component).should be(mock_view_component)
      end

      it "redirects to the created view_component" do
        ViewComponent.stub(:new) { mock_view_component(:save => true) }
        post :create, :view_component => {}
        response.should redirect_to(view_component_url(mock_view_component))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved view_component as @view_component" do
        ViewComponent.stub(:new).with({'these' => 'params'}) { mock_view_component(:save => false) }
        post :create, :view_component => {'these' => 'params'}
        assigns(:view_component).should be(mock_view_component)
      end

      it "re-renders the 'new' template" do
        ViewComponent.stub(:new) { mock_view_component(:save => false) }
        post :create, :view_component => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested view_component" do
        ViewComponent.stub(:find).with("37") { mock_view_component }
        mock_view_component.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :view_component => {'these' => 'params'}
      end

      it "assigns the requested view_component as @view_component" do
        ViewComponent.stub(:find) { mock_view_component(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:view_component).should be(mock_view_component)
      end

      it "redirects to the view_component" do
        ViewComponent.stub(:find) { mock_view_component(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(view_component_url(mock_view_component))
      end
    end

    describe "with invalid params" do
      it "assigns the view_component as @view_component" do
        ViewComponent.stub(:find) { mock_view_component(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:view_component).should be(mock_view_component)
      end

      it "re-renders the 'edit' template" do
        ViewComponent.stub(:find) { mock_view_component(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested view_component" do
      ViewComponent.stub(:find).with("37") { mock_view_component }
      mock_view_component.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the view_components list" do
      ViewComponent.stub(:find) { mock_view_component }
      delete :destroy, :id => "1"
      response.should redirect_to(view_components_url)
    end
  end

end
