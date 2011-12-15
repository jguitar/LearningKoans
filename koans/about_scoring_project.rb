require File.expand_path(File.dirname(__FILE__) + '/edgecase')

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

SET_OF_THREE = 3
FACE_ONE = 1
FACE_FIVE = 5

POINTS_FOR_THREE_ONES = 1000
POINTS_FOR_THREE_OTHER_THAN_ONES = 100
POINTS_FOR_A_ONE = 100
POINTS_FOR_A_FIVE = 50
ZERO_POINTS = 0

$count = 0

def create_histogram(dice)
  histogram = Hash.new(0)
  dice.each { |face| histogram[face] += 1 }
  return histogram
end

def check_three_rolls_equal(face, score)
  if $count >= SET_OF_THREE
    score += face == FACE_ONE ? POINTS_FOR_THREE_ONES : face * POINTS_FOR_THREE_OTHER_THAN_ONES
    $count -= SET_OF_THREE
  end
  return score
end

def check_other_rolls(face, score)
  score += if face == FACE_ONE
    POINTS_FOR_A_ONE * $count
  elsif face == FACE_FIVE
    POINTS_FOR_A_FIVE * $count
  else
    ZERO_POINTS
  end
  return score
end

def score(dice)  
  result = 0
  histogram = create_histogram(dice)
  histogram.each do |face, count|
    $count = count
    result = check_three_rolls_equal(face, result)
    result = check_other_rolls(face, result)
  end

  return result
end

class AboutScoringProject < EdgeCase::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, score([1])
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, score([1,5,5,1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, score([2,3,4,6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, score([1,1,1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, score([2,2,2])
    assert_equal 300, score([3,3,3])
    assert_equal 400, score([4,4,4])
    assert_equal 500, score([5,5,5])
    assert_equal 600, score([6,6,6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, score([2,5,2,2,3])
    assert_equal 550, score([5,5,5,5])
  end

end