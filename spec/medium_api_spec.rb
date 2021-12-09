RSpec.describe MediumApi do
  it "has a version number" do
    expect(MediumApi::VERSION).not_to be nil
  end

  subject(:medium_api) { described_class }

  describe ".configure" do
    let(:api_key) { 'ApiKey' }

    specify do
      medium_api.configure do |config|
        config.api_key = api_key
      end

      expect(medium_api.configuration.api_key).to eq(api_key)
    end
  end

  describe '.me' do
    let(:api_key) { '2ada46c383ae76af4ca4dcbe42f7611062644f366bd6281c2efe78202b35f3c60' }

    before do
      medium_api.configure do |config|
        config.api_key = api_key
      end
    end

    specify do
      user = VCR.use_cassette 'me' do
        medium_api.me
      end

      expect(user.name).to eq('Test Api Key')
      expect(user.image_url).to_not be_nil
    end
  end
end
