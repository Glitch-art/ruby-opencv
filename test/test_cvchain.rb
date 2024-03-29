#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8 -*-
require 'test/unit'
require File.expand_path(File.dirname(__FILE__)) + '/helper'
require 'opencv'

include OpenCV

# Tests for OpenCV::CvChain
class TestCvChain < OpenCVTestCase
  def test_APPROX_OPTION
    assert_equal(:approx_simple, CvChain::APPROX_CHAIN_OPTION[:method])
    assert_equal(0, CvChain::APPROX_CHAIN_OPTION[:parameter])
    assert_equal(0, CvChain::APPROX_CHAIN_OPTION[:minimal_perimeter])
    assert_false(CvChain::APPROX_CHAIN_OPTION[:recursive])
  end
  
  def test_initialize
    chain = CvChain.new
    assert_not_nil(chain)
    assert_equal(CvChain, chain.class)
    assert(chain.is_a? CvSeq)
  end

  def test_origin
    mat0 = create_cvmat(128, 128, :cv8u, 1) { |j, i|
      (j - 64) ** 2 + (i - 64) ** 2 <= (32 ** 2) ? CvColor::White : CvColor::Black
    }
    chain = mat0.find_contours(:mode => CV_RETR_EXTERNAL, :method => CV_CHAIN_CODE)
    assert_equal(CvChain, chain.class)
    assert_equal(64, chain.origin.x)
    assert_equal(32, chain.origin.y)

    chain.origin = CvPoint.new(32, 64)
    assert_equal(32, chain.origin.x)
    assert_equal(64, chain.origin.y)
  end

  def test_codes
    mat0 = create_cvmat(128, 128, :cv8u, 1) { |j, i|
      (j - 64) ** 2 + (i - 64) ** 2 <= (32 ** 2) ? CvColor::White : CvColor::Black
    }
    chain = mat0.find_contours(:mode => CV_RETR_EXTERNAL, :method => CV_CHAIN_CODE)
    assert_equal(Array, chain.codes.class)
    assert(chain.codes.all? { |a| (Integer === a) and (a >= 0 and a <= 7) })
  end

  def test_points
    mat0 = create_cvmat(128, 128, :cv8u, 1) { |j, i|
      (j - 64) ** 2 + (i - 64) ** 2 <= (32 ** 2) ? CvColor::White : CvColor::Black
    }
    chain = mat0.find_contours(:mode => CV_RETR_EXTERNAL, :method => CV_CHAIN_CODE)
    assert_equal(Array, chain.points.class)
    assert(chain.points.all? { |a| a.class == CvPoint })
  end

  def test_approx_chains
    mat0 = create_cvmat(128, 128, :cv8u, 1) { |j, i|
      (j - 64) ** 2 + (i - 64) ** 2 <= (32 ** 2) ? CvColor::White : CvColor::Black
    }
    chain = mat0.find_contours(:mode => CV_RETR_EXTERNAL, :method => CV_CHAIN_CODE)

    contours = chain.approx_chains
    assert_equal(CvChain, contours.class)
    assert(contours.size > 0)
    assert(contours.all? { |c| c.class == CvPoint })

    [CV_CHAIN_APPROX_NONE, CV_CHAIN_APPROX_SIMPLE,
     CV_CHAIN_APPROX_TC89_L1, CV_CHAIN_APPROX_TC89_KCOS,
     :approx_none, :approx_simple, :approx_tc89_l1, :approx_tc89_kcos].each { |method|
      contours = chain.approx_chains(:method => method)
      assert_equal(CvChain, contours.class)
      assert(contours.size > 0)
      assert(contours.all? { |c| c.class == CvPoint })
    }

    contours = chain.approx_chains(:minimal_parameter => 10)
    assert_equal(CvChain, contours.class)
    assert(contours.size > 0)
    assert(contours.all? { |c| c.class == CvPoint })

    contours = chain.approx_chains(:minimal_perimeter => (32 * 2 * Math::PI).ceil)
    assert_nil(contours)

    [true, false].each { |recursive|
      contours = chain.approx_chains(:recursive => recursive)
      assert_equal(CvChain, contours.class)
      assert(contours.size > 0)
      assert(contours.all? { |c| c.class == CvPoint })
    }

    contours = chain.approx_chains(:method => :approx_simple,
                                  :minimal_parameter => 100, :recursive => false)
    assert_equal(CvChain, contours.class)
    assert(contours.size > 0)
    assert(contours.all? { |c| c.class == CvPoint })

    # Uncomment the following lines to show the result
    # contours = chain.approx_chains
    # dst = mat0.clone.zero
    # begin
    #   dst.draw_contours!(contours, CvColor::White, CvColor::Black, 2,
    #                      :thickness => 1, :line_type => :aa)
    # end while (contours = contours.h_next)
    # snap dst
  end
end

