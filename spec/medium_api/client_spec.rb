require 'spec_helper'

RSpec.describe MediumApi::Client do
  subject(:client) { described_class.new(api_key: api_key) }
  let(:api_key) { '2ada46c383ae76af4ca4dcbe42f7611062644f366bd6281c2efe78202b35f3c60' }

  describe '#me' do
    specify do
      me = VCR.use_cassette 'me' do
        client.me
      end

      expect(me['name']).to eq('Test Api Key')
    end

    context 'when api_key is incorrect' do
      let(:api_key) { 'asd' }

      specify do
        VCR.use_cassette 'me/incorrect_api_key' do
          expect { client.me }.to raise_error(MediumApi::Error::UnauthorizedError)
        end
      end
    end
  end

  describe '#user_publications' do
    let(:user_id) { '1b619f0be1bc842ffc55e8a20c7d6c9129ba896467b90ab9e23b86a36fdd2a67e' }

    specify do
      publications = VCR.use_cassette 'user_publications' do
        client.user_publications(user_id)
      end

      expect(publications.size).to eq(1)
      expect(publications.first['name']).to eq('ILLUMINATION')
    end

    context 'when user_id is incorrect' do
      let(:user_id) { 'test' }

      specify do
        VCR.use_cassette 'user_publications/incorrect_user_id' do
          expect { client.user_publications(user_id) }.to raise_error(MediumApi::Error::BadRequestError)
        end
      end
    end
  end

  describe '#publication_contributors' do
    let(:publication_id) { 'eca1ba5ae1ca' }

    specify do
      contributors = VCR.use_cassette 'publication_contributors' do
        client.publication_contributors(publication_id)
      end

      expect(contributors.size).to eq(1030)
    end

    context 'when publication_id is incorrect' do
      let(:publication_id) { 'test' }

      specify do
        VCR.use_cassette 'publication_contributors/incorrect_publication_id' do
          data = client.publication_contributors(publication_id)

          expect(data).to be_empty
        end
      end
    end
  end

  describe '#create_user_posts' do
    let(:user_id) { '1b619f0be1bc842ffc55e8a20c7d6c9129ba896467b90ab9e23b86a36fdd2a67e' }
    let(:post_attributes) do
      {
        title: 'Test Title',
        content: '<h1>Test Title</h1>',
        content_format: 'html'
      }
    end

    specify do
      data = VCR.use_cassette 'create_user_post' do
        client.create_user_post(user_id, post_attributes)
      end

      expect(data['id']).to eq('695e96144fba')
    end

    context 'when required post_attributes are missing' do
      let(:post_attributes) do
        {}
      end

      specify do
        VCR.use_cassette 'create_user_post/incorrect_attributes' do
          expect { client.create_user_post(user_id, post_attributes) }.to raise_error(MediumApi::Error::BadRequestError)
        end
      end
    end

    context 'when required post_attributes are missing' do
      let(:user_id) { 'real_user_id' }

      specify do
        VCR.use_cassette 'create_user_post/incorrect_user_id' do
          expect { client.create_user_post(user_id, post_attributes) }.to raise_error(MediumApi::Error::ForbiddenError)
        end
      end
    end
  end
end
