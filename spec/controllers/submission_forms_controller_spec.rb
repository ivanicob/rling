require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe SubmissionFormsController do

  def mock_submission_form(stubs={})
    @mock_submission_form ||= mock_model(SubmissionForm, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all submission_forms as @submission_forms" do
      SubmissionForm.stub(:all) { [mock_submission_form] }
      get :index
      assigns(:submission_forms).should eq([mock_submission_form])
    end
  end

  describe "GET show" do
    it "assigns the requested submission_form as @submission_form" do
      SubmissionForm.stub(:find).with("37") { mock_submission_form }
      get :show, :id => "37"
      assigns(:submission_form).should be(mock_submission_form)
    end
  end

  describe "GET new" do
    it "assigns a new submission_form as @submission_form" do
      SubmissionForm.stub(:new) { mock_submission_form }
      get :new
      assigns(:submission_form).should be(mock_submission_form)
    end
  end

  describe "GET edit" do
    it "assigns the requested submission_form as @submission_form" do
      SubmissionForm.stub(:find).with("37") { mock_submission_form }
      get :edit, :id => "37"
      assigns(:submission_form).should be(mock_submission_form)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created submission_form as @submission_form" do
        SubmissionForm.stub(:new).with({'these' => 'params'}) { mock_submission_form(:save => true) }
        post :create, :submission_form => {'these' => 'params'}
        assigns(:submission_form).should be(mock_submission_form)
      end

      it "redirects to the created submission_form" do
        SubmissionForm.stub(:new) { mock_submission_form(:save => true) }
        post :create, :submission_form => {}
        response.should redirect_to(submission_form_url(mock_submission_form))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved submission_form as @submission_form" do
        SubmissionForm.stub(:new).with({'these' => 'params'}) { mock_submission_form(:save => false) }
        post :create, :submission_form => {'these' => 'params'}
        assigns(:submission_form).should be(mock_submission_form)
      end

      it "re-renders the 'new' template" do
        SubmissionForm.stub(:new) { mock_submission_form(:save => false) }
        post :create, :submission_form => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested submission_form" do
        SubmissionForm.stub(:find).with("37") { mock_submission_form }
        mock_submission_form.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :submission_form => {'these' => 'params'}
      end

      it "assigns the requested submission_form as @submission_form" do
        SubmissionForm.stub(:find) { mock_submission_form(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:submission_form).should be(mock_submission_form)
      end

      it "redirects to the submission_form" do
        SubmissionForm.stub(:find) { mock_submission_form(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(submission_form_url(mock_submission_form))
      end
    end

    describe "with invalid params" do
      it "assigns the submission_form as @submission_form" do
        SubmissionForm.stub(:find) { mock_submission_form(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:submission_form).should be(mock_submission_form)
      end

      it "re-renders the 'edit' template" do
        SubmissionForm.stub(:find) { mock_submission_form(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested submission_form" do
      SubmissionForm.stub(:find).with("37") { mock_submission_form }
      mock_submission_form.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the submission_forms list" do
      SubmissionForm.stub(:find) { mock_submission_form }
      delete :destroy, :id => "1"
      response.should redirect_to(submission_forms_url)
    end
  end

end
