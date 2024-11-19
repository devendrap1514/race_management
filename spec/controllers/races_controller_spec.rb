require 'rails_helper'

RSpec.describe RacesController, type: :controller do
  let(:race) { create(:race) }
  let!(:student1) { create(:student) }
  let!(:student2) { create(:student) }
  let(:valid_attributes) do
    {
      name: 'Race 1',
      student_races_attributes: [
        { student_id: student1.id, lane: 1 },
        { student_id: student2.id, lane: 2 }
      ]
    }
  end

  let(:invalid_attributes) { { name: '', student_races_attributes: [] } }

  describe 'GET #index' do
    it 'assigns all races to @races' do
      get :index
      expect(assigns(:races)).to eq([race])
    end
  end

  describe 'GET #new' do
    it 'assigns a new race to @race and @students' do
      get :new
      expect(assigns(:race)).to be_a_new(Race)
      expect(assigns(:students).to_a).to eq(Student.all.to_a)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new race and redirects to races path' do
        expect do
          post :create, params: { race: valid_attributes }
        end.to change(Race, :count).by(1)

        expect(response).to redirect_to(races_path)
        expect(flash[:notice]).to eq(I18n.t('message.create.race'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new race and re-renders the new template with unprocessable_entity status' do
        expect do
          post :create, params: { race: invalid_attributes }
        end.to_not change(Race, :count)

        expect(response).to render_template(:new)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested race to @race' do
      get :edit, params: { id: race.id }
      expect(assigns(:race)).to eq(race)
    end

    it 'redirects to races path if race not found' do
      get :edit, params: { id: '0' }
      expect(response).to redirect_to(races_path)
      expect(flash[:alert]).to eq(I18n.t('message.not_found.race'))
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the requested race and redirects to races path' do
        valid_attributes = {
          student_races_attributes: race.student_races.map.with_index { |student_race, index|
            {
              id: student_race.id,
              position: index+1
            }
          }
        }
        patch :update, params: { id: race.id, race: valid_attributes }
        expect(response).to redirect_to(races_path)
        expect(flash[:notice]).to eq(I18n.t('message.update.race'))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the race and re-renders the edit template with unprocessable_entity status' do
        invalid_attributes = {
          student_races_attributes: race.student_races.map.with_index { |student_race, index|
            {
              id: student_race.id,
              position: 2
            }
          }
        }
        patch :update, params: { id: race.id, race: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested race and redirects to races path' do
      race
      expect do
        delete :destroy, params: { id: race.id }
      end.to change(Race, :count).by(-1)

      expect(response).to redirect_to(races_path)
      expect(flash[:notice]).to eq(I18n.t('message.delete.race'))
    end
  end
end
