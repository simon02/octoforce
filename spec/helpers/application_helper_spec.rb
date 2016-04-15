require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do

  describe '#filter_link_params' do
    it 'works without params' do
      o = Update.new id: 1
      expect(helper.filter_link_params o, o.id).to eq update: 1
    end

    it 'works with existing params without overlap' do
      o = Update.new id: 1
      params = {something_else: [13,5]}
      result = helper.filter_link_params o, o.id, params
      expect(result).to eq params.merge update: o.id
    end

    it 'works with existing params with overlap' do
      o = Update.new id: 1
      p1 = {something_else: [13,5], update: 4}
      p2 = {something_else: [13,5], update: [4,2]}
      r1 = helper.filter_link_params o, o.id, p1
      r2 = helper.filter_link_params o, o.id, p2
      expect(r1).to eq({ something_else: [13,5], update: [4, 1] })
      expect(r2).to eq({ something_else: [13,5], update: [4, 2, 1] })
    end

    it 'works with symbolized keys' do
      o = Update.new id: 1
      p1 = {something_else: [13,5], update: 1}
      p2 = {something_else: [13,5], update: [1,2]}
      r1 = helper.filter_link_params o, o.id, p1
      r2 = helper.filter_link_params o, o.id, p2
      expect(r1).to eq({ something_else: [13,5]})
      expect(r2).to eq({ something_else: [13,5], update: [2] })
    end

    it 'works with string keys' do
      o = Update.new id: 1
      p1 = {something_else: [13,5], "update" => 1}
      p2 = {something_else: [13,5], "update" => [1,2]}
      r1 = helper.filter_link_params o, o.id, p1
      r2 = helper.filter_link_params o, o.id, p2
      expect(r1).to eq({ something_else: [13,5]})
      expect(r2).to eq({ something_else: [13,5], update: [2] })
    end

    it 'works with string values' do
      o = Update.new id: 1
      p1 = {something_else: [13,5], "update" => "yellow"}
      p2 = {something_else: [13,5], update: ["yellow","green"]}
      r1 = helper.filter_link_params o, "yellow", p1
      r2 = helper.filter_link_params o, "yellow", p2
      expect(r1).to eq({ something_else: [13,5]})
      expect(r2).to eq({ something_else: [13,5], update: ["green"] })
    end

  end

end
