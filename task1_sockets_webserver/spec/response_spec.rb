require_relative '../src/response'

RSpec.describe Response, '#tokenize_timezone' do
    it 'filter any whitespace' do
      expect(Response.tokenize_timezone "b i   s\t \n \r hkek").to eq 'bishkek'
    end

    it 'downcase English chars' do
      expect(Response.tokenize_timezone "NeWyOrK").to eq 'newyork'
    end

    it 'filter any other chars, like Russian' do
      expect(Response.tokenize_timezone "Бишкек").to eq ''
      expect(Response.tokenize_timezone "БишкекBishkek").to eq 'bishkek'
    end

    it 'filter any numbers and special characters' do
      expect(Response.tokenize_timezone "Mo1s2c3o4!@#$%^&*()_,w").to eq 'moscow'
    end
end
