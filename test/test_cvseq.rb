#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8 -*-
require 'test/unit'
require File.expand_path(File.dirname(__FILE__)) + '/helper'
require 'opencv'

include OpenCV

# Tests for OpenCV::CvSeq
class TestCvSeq < OpenCVTestCase
  def test_initialize
    types = [CV_SEQ_ELTYPE_POINT, CV_SEQ_ELTYPE_POINT3D, CV_SEQ_ELTYPE_CODE, CV_SEQ_ELTYPE_INDEX]
    kinds = [CV_SEQ_KIND_GENERIC, CV_SEQ_KIND_CURVE, CV_SEQ_KIND_BIN_TREE, CV_SEQ_KIND_GRAPH, CV_SEQ_KIND_SUBDIV2D]
    flags = [CV_SEQ_FLAG_CLOSED, CV_SEQ_FLAG_SIMPLE, CV_SEQ_FLAG_CONVEX, CV_SEQ_FLAG_HOLE]
    types.each { |type|
      kinds.each { |kind|
        flags.each { |flag|
          seq_flag = type | kind | flag
          assert_equal(CvSeq, CvSeq.new(seq_flag).class)
        }
      }
    }

    [CV_SEQ_POINT_SET, CV_SEQ_POINT3D_SET, CV_SEQ_POLYLINE, CV_SEQ_POLYGON,
     CV_SEQ_CONTOUR, CV_SEQ_SIMPLE_POLYGON, CV_SEQ_CHAIN, CV_SEQ_CHAIN_CONTOUR,
     CV_SEQ_INDEX ].each { |seq_flag|
      assert_equal(CvSeq, CvSeq.new(seq_flag).class)
    }

    # Unsupported types
    [CV_SEQ_ELTYPE_PTR, CV_SEQ_ELTYPE_PPOINT].each { |type|
      assert_raise(ArgumentError) {
        CvSeq.new(type)
      }
    }
  end

  def test_total
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT)
    assert_equal(0, seq1.total)

    seq1.push(CvPoint.new(1, 2))
    assert_equal(1, seq1.total)

    seq1.push(CvPoint.new(3, 4))
    assert_equal(2, seq1.total)
    # Alias
    assert_equal(2, seq1.length)
    assert_equal(2, seq1.size)
  end

  def test_empty
    assert(CvSeq.new(CV_SEQ_ELTYPE_POINT).empty?)
  end
  
  def test_aref
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT)
    seq1.push(CvPoint.new(10, 20), CvPoint.new(30, 40), CvPoint.new(50, 60))

    assert_equal(CvPoint, seq1[0].class)
    assert_equal(10, seq1[0].x)
    assert_equal(20, seq1[0].y)
    assert_equal(30, seq1[1].x)
    assert_equal(40, seq1[1].y)
    assert_equal(50, seq1[2].x)
    assert_equal(60, seq1[2].y)
    
    seq2 = CvSeq.new(CV_SEQ_ELTYPE_INDEX)
    seq2.push(10, 20, 30)
    assert_kind_of(Integer, seq2[0])
    assert_equal(10, seq2[0])
    assert_equal(20, seq2[1])
    assert_equal(30, seq2[2])
  end

  def test_push
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT).push(CvPoint.new(10, 20), CvPoint.new(30, 40))
    
    assert_equal(2, seq1.total)
    assert_equal(CvPoint, seq1[0].class)
    assert_equal(10, seq1[0].x)
    assert_equal(20, seq1[0].y)
    assert_equal(CvPoint, seq1[1].class)
    assert_equal(30, seq1[1].x)
    assert_equal(40, seq1[1].y)

    seq2 = CvSeq.new(CV_SEQ_ELTYPE_POINT).push(CvPoint.new(50, 60))
    seq2.push(seq1)
    assert_equal(3, seq2.total)
    assert_equal(CvPoint, seq2[0].class)
    assert_equal(50, seq2[0].x)
    assert_equal(60, seq2[0].y)
    assert_equal(CvPoint, seq2[1].class)
    assert_equal(10, seq2[1].x)
    assert_equal(20, seq2[1].y)
    assert_equal(CvPoint, seq2[2].class)
    assert_equal(30, seq2[2].x)
    assert_equal(40, seq2[2].y)

    seq3 = CvSeq.new(CV_SEQ_ELTYPE_INDEX).push(10)
    seq4 = CvSeq.new(CV_SEQ_ELTYPE_INDEX).push(20, 30)
    seq3.push(seq4)
    assert_equal(3, seq3.total)
    assert_kind_of(Integer, seq3[0])
    assert_equal(10, seq3[0])
    assert_equal(20, seq3[1])
    assert_equal(30, seq3[2])

    assert_raise(TypeError) {
      seq1.push(55.5, 66.6)
    }

    assert_raise(TypeError) {
      seq3 = CvSeq.new(CV_SEQ_ELTYPE_INDEX).push(55, 66)
      seq1.push(seq3)
    }
  end

  def test_pop
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT).push(CvPoint.new(10, 20), CvPoint.new(30, 40))
    point1 = seq1.pop
    assert_equal(CvPoint, point1.class)
    assert_equal(30, point1.x)
    assert_equal(40, point1.y)

    assert_equal(1, seq1.total)
    assert_equal(CvPoint, seq1[0].class)
    assert_equal(10, seq1[0].x)
    assert_equal(20, seq1[0].y)

    assert_nil(CvSeq.new(CV_SEQ_ELTYPE_POINT).pop)

    seq2 = CvSeq.new(CV_SEQ_ELTYPE_INDEX).push(10, 20, 30)
    assert_equal(30, seq2.pop)
    assert_equal(20, seq2.pop)
    assert_equal(10, seq2.pop)
  end

  def test_clear
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT).push(CvPoint.new(10, 20), CvPoint.new(30, 40))
    seq1.clear
    assert_not_nil(seq1)
    assert_equal(0, seq1.total)
  end

  def test_unshift
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT).unshift(CvPoint.new(10, 20), CvPoint.new(30, 40))
    
    assert_equal(2, seq1.total)
    assert_equal(CvPoint, seq1[0].class)
    assert_equal(30, seq1[0].x)
    assert_equal(40, seq1[0].y)
    assert_equal(CvPoint, seq1[1].class)
    assert_equal(10, seq1[1].x)
    assert_equal(20, seq1[1].y)

    seq2 = CvSeq.new(CV_SEQ_ELTYPE_POINT).unshift(CvPoint.new(50, 60))
    seq2.unshift(seq1)
    assert_equal(3, seq2.total)
    assert_equal(CvPoint, seq1[0].class)
    assert_equal(30, seq1[0].x)
    assert_equal(40, seq1[0].y)
    assert_equal(CvPoint, seq1[1].class)
    assert_equal(10, seq1[1].x)
    assert_equal(20, seq1[1].y)
    assert_equal(CvPoint, seq2[2].class)
    assert_equal(50, seq2[2].x)
    assert_equal(60, seq2[2].y)

    seq3 = CvSeq.new(CV_SEQ_ELTYPE_INDEX).unshift(10, 20, 30)
    assert_equal(3, seq3.total)
    assert_equal(30, seq3[0])
    assert_equal(20, seq3[1])
    assert_equal(10, seq3[2])

    assert_raise(TypeError) {
      seq1.unshift(10)
    }

    assert_raise(TypeError) {
      seq3 = CvSeq.new(CV_SEQ_ELTYPE_INDEX).push(10, 20, 30)
      seq1.unshift(seq3)
    }
  end

  def test_shift
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT).push(CvPoint.new(10, 20), CvPoint.new(30, 40))
    point1 = seq1.shift
    assert_equal(CvPoint, point1.class)
    assert_equal(10, point1.x)
    assert_equal(20, point1.y)

    assert_equal(1, seq1.total)
    assert_equal(CvPoint, seq1[0].class)
    assert_equal(30, seq1[0].x)
    assert_equal(40, seq1[0].y)

    seq2 = CvSeq.new(CV_SEQ_ELTYPE_INDEX).push(10, 20, 30)
    assert_equal(10, seq2.shift)
    assert_equal(20, seq2.shift)
    assert_equal(30, seq2.shift)

    assert_nil(CvSeq.new(CV_SEQ_ELTYPE_POINT).shift)
  end

  def test_first
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT).push(CvPoint.new(10, 20), CvPoint.new(30, 40), CvPoint.new(50, 60))
    point1 = seq1.first
    assert_equal(CvPoint, point1.class)
    assert_equal(10, point1.x)
    assert_equal(20, point1.y)

    seq2 = CvSeq.new(CV_SEQ_ELTYPE_INDEX).push(10, 20, 30)
    assert_equal(10, seq2.first)
  end

  def test_last
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT).push(CvPoint.new(10, 20), CvPoint.new(30, 40), CvPoint.new(50, 60))
    point1 = seq1.last
    assert_equal(CvPoint, point1.class)
    assert_equal(50, point1.x)
    assert_equal(60, point1.y)

    seq2 = CvSeq.new(CV_SEQ_ELTYPE_INDEX).push(10, 20, 30)
    assert_equal(30, seq2.last)
  end

  def test_each
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT).push(CvPoint.new(10, 20), CvPoint.new(30, 40), CvPoint.new(50, 60))
    i = 0
    seq1.each { |s|
      assert_equal(CvPoint, s.class)
      assert_equal(seq1[i].x, s.x)
      assert_equal(seq1[i].y, s.y)
      i += 1
    }
    assert_equal(3, i)

    seq2 = CvSeq.new(CV_SEQ_ELTYPE_INDEX).push(10, 20, 30)
    i = 0
    seq2.each { |s|
      assert_equal(seq2[i], s)
      i += 1
    }
    assert_equal(3, i)
  end

  def test_each_index
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT).push(CvPoint.new(10, 20), CvPoint.new(30, 40), CvPoint.new(50, 60))
    n = 0
    seq1.each_index { |i|
      assert_equal(n, i)
      n += 1
    }
    assert_equal(3, n)
  end

  def test_insert
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT).push(CvPoint.new(10, 20), CvPoint.new(30, 40))
    seq1.insert(1, CvPoint.new(50, 60))
    assert_equal(3, seq1.total)
    assert_equal(CvPoint, seq1[0].class)
    assert_equal(10, seq1[0].x)
    assert_equal(20, seq1[0].y)
    assert_equal(CvPoint, seq1[1].class)
    assert_equal(50, seq1[1].x)
    assert_equal(60, seq1[1].y)
    assert_equal(CvPoint, seq1[2].class)
    assert_equal(30, seq1[2].x)
    assert_equal(40, seq1[2].y)

    seq2 = CvSeq.new(CV_SEQ_ELTYPE_INDEX).push(10, 20)
    seq2.insert(1, 15)
    assert_equal(3, seq2.total)
    assert_equal(10, seq2[0])
    assert_equal(15, seq2[1])
    assert_equal(20, seq2[2])
  end

  def test_remove
    seq1 = CvSeq.new(CV_SEQ_ELTYPE_POINT).push(CvPoint.new(10, 20), CvPoint.new(30, 40), CvPoint.new(50, 60))

    seq1.remove(1)
    assert_equal(2, seq1.total)
    assert_equal(CvPoint, seq1[0].class)
    assert_equal(10, seq1[0].x)
    assert_equal(20, seq1[0].y)
    assert_equal(CvPoint, seq1[1].class)
    assert_equal(50, seq1[1].x)
    assert_equal(60, seq1[1].y)
  end

  # These methods are tested in TestCvMat_imageprocessing#test_find_contours
  # (test_cvmat_imageprocessing.rb)
  # def test_h_prev
  #   flunk('FIXME: CvSeq#h_prev is not tested yet.')
  # end

  # def test_h_next
  #   flunk('FIXME: CvSeq#h_next is not tested yet.')
  # end

  # def test_v_prev
  #   flunk('FIXME: CvSeq#v_prev is not tested yet.')
  # end

  # def test_v_next
  #   flunk('FIXME: CvSeq#v_next is not tested yet.')
  # end
end

