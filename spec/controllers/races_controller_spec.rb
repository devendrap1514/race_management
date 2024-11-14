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

  before do
    create(:student_race, race: race, student: student1, lane: 1)
    create(:student_race, race: race, student: student2, lane: 2)
  end

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
        expect(flash[:notice]).to eq(I18n.t('race.created'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new race and re-renders the new template' do
        expect do
          post :create, params: { race: invalid_attributes }
        end.to_not change(Race, :count)

        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to include("Name can't be blank")
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested race to @race' do
      get :edit, params: { id: race.id }
      expect(assigns(:race)).to eq(race)
    end

    it 'redirect to index page if race not found' do
      get :edit, params: { id: '0' }
      expect(response).to redirect_to(races_path)
    end
  end

  describe 'PATCH #update' do
    context 'with valid positions and valid student data' do
      let(:valid_positions) { [1, 2] }

      before do
        patch :update, params: { id: race.id, student_ids: [student1.id, student2.id], positions: valid_positions }
      end

      it 'updates the race and redirects to races path' do
        expect(response).to redirect_to(races_path)
        expect(flash[:notice]).to eq(I18n.t('race.updated'))
      end
    end

    context 'with valid positions and valid student but not able to update' do
      let(:valid_positions) { [1, 2] }



      it 'not updates the race and redirects to races edit path' do
        allow_any_instance_of(RacesController).to receive(:update_positions).and_return(false)
        patch :update, params: { id: race.id, student_ids: [student1.id, student2.id], positions: valid_positions }
        expect(response).to redirect_to(edit_race_path(race.id))
        expect(flash[:alert]).to eq(I18n.t('race.invalid_student_data'))
      end
    end

    context 'when student_ids and positions do not match' do
      it 'returns an alert message and re-renders edit page' do
        patch :update, params: { id: race.id, student_ids: [student1.id], positions: [1, 2] }
        expect(response).to redirect_to(edit_race_path(race.id))
        expect(flash[:alert]).to eq(I18n.t('race.position_required'))
      end
    end

    context 'when position validation fails' do
      it 'returns an alert message and redirects to edit page' do
        patch :update, params: { id: race.id, student_ids: [student1.id, student2.id], positions: [1, 3] }

        expect(response).to redirect_to(edit_race_path(race.id))
        expect(flash[:alert]).to eq(I18n.t('check_position_service.errors.invalid_positions'))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested race and redirects to races path' do
      expect do
        delete :destroy, params: { id: race.id }
      end.to change(Race, :count).by(-1)

      expect(response).to redirect_to(races_path)
      expect(flash[:notice]).to eq(I18n.t('race.deleted'))
    end
  end
end
