RSpec.describe "Viewing the skill menu" do
  let!(:path1){ TrainingPath.create(name: "Running") }
  let!(:path2){ TrainingPath.create(name: "Hand-to-Hand Combat") }

  context "a training path that is in the list" do
    let(:output){ run_zss_with_input('2') } # Hand-to-Hand Combat

    before do
      Skill.create(name: "with Scissors", description: "Not the best idea", training_path: path1)
      Skill.create(name: "like a Zombie", description: "Even worse idea", training_path: path1)
      Skill.create(name: "with weapons because you want to win", description: "A little better", training_path: path2)
      Skill.create(name: "using your fingernails", description: "Boom", training_path: path2)
    end

    it "should include the name of the training path being viewed" do
      expect(output).to include("We're headed down the path to Hand-to-Hand Combat!")
    end
    it "should list the skills in this training path" do
      expected = "1. with weapons because you want to win\n" +
                 "2. using your fingernails\n"
      expect(output).to include(expected)
    end
    it "shouldn't list the skills in other training paths" do
      expect(output).not_to include("with Scissors")
      expect(output).not_to include("like a Zombie")
    end
    it "should allow the user to select a skill to master" do
      selection = run_zss_with_input('2', '1')
      # let(:selection){ run_zss_with_input('1') }
      expect(selection).to include("A little better")
    end
    it "should prompt the user with 'Have you mastered this skill?'" do
      selection = run_zss_with_input('2', '1')
      expect(selection).to include("Have you mastered this skill? (y/n)")
    end
    it "should prompt the user with 'You have mastered this skill'" do
      run_zss_with_input('2', '1', 'y')
      selection = run_zss_with_input('2', '1')
      expect(selection).to include "You mastered this skill on #{DateTime.now.to_s}"
    end
  end

  context "if we enter a training path the doesn't exist" do
    let(:output){ run_zss_with_input('3') }
    it "prints an error message" do
      expect(output).to include("Sorry, training path 3 doesn't exist.")
    end
  end
end
