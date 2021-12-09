require 'spec_helper'

RSpec.describe MediumApi::Publication do
  describe '#contributors' do
    let(:publication) { described_class.new(id: 'eca1ba5ae1ca') }

    specify do
      contributors = VCR.use_cassette 'publication_contributors' do
        publication.contributors
      end

      expect(contributors.size).to eq(1030)
    end
  end
end
