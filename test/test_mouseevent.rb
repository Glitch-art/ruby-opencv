#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8 -*-
require 'test/unit'
require File.expand_path(File.dirname(__FILE__)) + '/helper'
require 'opencv'

include OpenCV
include GUI

# Tests for OpenCV::MouseEvent
class TestMouseEvent < OpenCVTestCase
  def test_initialize
    assert_not_nil(MouseEvent.new)
    assert_equal(MouseEvent, MouseEvent.new.class)
  end
end

