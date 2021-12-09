require 'spec_helper'

RSpec.describe MediumApi::User do
  describe '#publications' do
    let(:user) { described_class.new(id: '1b619f0be1bc842ffc55e8a20c7d6c9129ba896467b90ab9e23b86a36fdd2a67e') }

    specify do
      publications = VCR.use_cassette 'user_publications' do
        user.publications
      end

      expect(publications.size).to eq(1)
      expect(publications.first.name).to eq('ILLUMINATION')
    end
  end

  describe '#create_post' do
    let(:user) { described_class.new(id: '1b619f0be1bc842ffc55e8a20c7d6c9129ba896467b90ab9e23b86a36fdd2a67e') }
    let(:post_attributes) do
      {
        title: 'Test Title',
        content: '<h1>Test Title</h1>',
        content_format: 'html'
      }
    end

    specify do
      post = VCR.use_cassette 'create_user_post' do
        user.create_post(post_attributes)
      end

      expect(post.id).to eq('695e96144fba')
    end
  end
end
