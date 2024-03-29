#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8 -*-
require 'test/unit'
require File.expand_path(File.dirname(__FILE__)) + '/helper'
require 'opencv'

include OpenCV

# Tests for OpenCV::CvAvgComp
class TestCvAvgComp < OpenCVTestCase
  def setup
    @avgcomp = CvAvgComp.new
  end

  def test_initialize
    assert_equal(CvAvgComp, @avgcomp.class)
    assert(@avgcomp.is_a? CvRect)
  end

  def test_neighbors
    assert_kind_of(Integer, @avgcomp.neighbors)
  end
end

