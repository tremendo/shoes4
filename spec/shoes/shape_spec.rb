require 'shoes/spec_helper'

describe Shoes::Shape do
  include_context "dsl app"

  let(:style) { Hash.new }
  let(:draw)  { Proc.new { } }

  subject { Shoes::Shape.new app, parent, style, draw }

  it_behaves_like "object with style" do
    let(:subject_without_style) { Shoes::Shape.new(app, parent) }
    let(:subject_with_style) { Shoes::Shape.new(app, parent, arg_styles) }
  end

  it_behaves_like "movable object"

  describe "octagon" do
    let(:draw) {
      Proc.new {
        xs = [200, 300, 370, 370, 300, 200, 130, 130]
        ys = [100, 100, 170, 270, 340, 340, 270, 170]
        move_to xs.first, ys.first
        xs.zip(ys).each do |x, y|
          line_to(x, y)
        end
        line_to xs.first, ys.first
      }
    }

    its(:left) { should be_nil }
    its(:top) { should be_nil }
    its(:left_bound) { should eq(130) }
    its(:top_bound) { should eq(100) }
    its(:right_bound) { should eq(370) }
    its(:bottom_bound) { should eq(340) }
    its(:width) { should eq(app.width) }
    its(:height) { should eq app.height }

    it_behaves_like "movable object"

    describe "when created with left and top values" do
      let(:style) { {left: 10, top: 100} }

      its(:left) { should eq(10) }
      its(:top) { should eq(100) }
      its(:left_bound) { should eq(130) }
      its(:top_bound) { should eq(100) }
      its(:right_bound) { should eq(370) }
      its(:bottom_bound) { should eq(340) }
      its(:width) { should eq(app.width) }
      its(:height) { should eq app.height }
    end
  end

  describe "curve" do
    let(:draw) {
      Proc.new {
        move_to 10, 10
        curve_to 20, 30, 100, 200, 50, 50
      }
    }

    its(:left_bound)   { should eq(10) }
    its(:top_bound)    { should eq(10) }
    its(:right_bound)  { should eq(100) }
    its(:bottom_bound) { should eq(200) }
    its(:width) { should eq(app.width) }
    its(:height) { should eq app.height }

    it_behaves_like "movable object"
  end

  describe "arc" do
    let(:draw) {
      Proc.new {
        arc 10, 10, 100, 100, Shoes::PI, Shoes::TWO_PI
      }
    }

    it_behaves_like "movable object"
  end

  describe "accesses app" do
    let(:draw) {
      Proc.new {
        background Shoes::COLORS[:red]
        stroke Shoes::COLORS[:blue]
        rect 10, 10, 100, 100
      }
    }

    it_behaves_like "movable object"
  end
end
