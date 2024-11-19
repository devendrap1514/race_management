require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(assigns(:student)).to be_a_new(Student)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new student and redirects to the races path' do
        expect {
          post :create, params: { student: { name: 'John Doe' } }
        }.to change(Student, :count).by(1)

        expect(response).to redirect_to(races_path)
        expect(flash[:notice]).to eq(I18n.t('message.create.student'))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new student and redirects to the new student path' do
        expect {
          post :create, params: { student: { name: '' } }
        }.not_to change(Student, :count)

        expect(assigns(:student).errors[:name]).to include(I18n.t('active_record.errors.models.student.attributes.name.blank'))
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
