# frozen_string_literal: true
describe DynVar do
  let(:default_value) { double(:default_value) }
  let(:variable) { DynVar.new(default_value) }

  around do |spec|
    begin
      aoe = Thread.abort_on_exception
      Thread.abort_on_exception = true
      spec.run
    ensure
      Thread.abort_on_exception = aoe
    end
  end

  describe 'accessibility' do
    it 'is accessible' do
      expect(variable.get).to eq(default_value)
    end

    it 'is accessible inside Thread.new' do
      initialize_now(variable, default_value)
      Thread.new { expect(variable.get).to eq(default_value) }.join
    end

    it 'is accessible inside Thread.start' do
      initialize_now(variable, default_value)
      Thread.start { expect(variable.get).to eq(default_value) }.join
    end

    context 'variable defined inside thread' do
      it 'is accessible outside thread' do
        var = nil
        Thread.new { var = DynVar.new(default_value) }.join
        expect(var.get).to eq(default_value)
      end
    end
  end

  it 'works as a stack' do
    new_value = double(:new_value)

    variable.set(new_value) do
      expect(variable.get).to eq(new_value)
    end

    expect(variable.get).to eq(default_value)
  end
end
