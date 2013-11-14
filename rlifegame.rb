# -*- coding: utf-8 -*-
#
# LifeGame by Ruby
#

require 'curses'
include Curses

M = 60 # row
N = 60 # column

# Initialization
noecho  # init_screen() is called in this method
win = stdscr.subwin(M+2, N*2+2, 3, 6)
win.box(?|,?-,?+)
curs_set(0)  # invisible cursor

field = Array.new(M+2){Array.new(N+2,0)}

# :sts -> 0 (dead) or 1 (living)
# :adj -> adjacent number around the self
Cell = Struct.new(:sts,:adj)

(M+2).times do |i|
  (N+2).times do |j|
    field[i][j] = Cell.new(0,0)
  end
end

def print_screen(subw,ary)
  (M+2).times do |i|
    (N+2).times do |j|
      if (i >= 1) && (i <= M) && (j >= 1) && (j <= N)
        if (ary[i][j].sts == 1)
          subw.setpos(i,j*2-1)
          subw.addstr('@')
        else
          subw.setpos(i,j*2-1)
          subw.addstr(' ')
        end
      end
    end
  end
  subw.refresh
  getch
end

def count_around(ary,i,j)
  count = 0
  (i-1..i+1).each do |m|
    (j-1..j+1).each do |n|
      if ((m != i) || (n != j)) && (ary[m][n].sts == 1)
        count += 1
      end
    end
  end
  count
end

def lifegame(ary)
  (1..M).each do |i|
    (1..N).each do |j|
      ary[i][j].adj = count_around(ary,i,j)
    end
  end
  (1..M).each do |i|
    (1..N).each do |j|
      if (ary[i][j].sts == 0) # dead
        if (ary[i][j].adj == 3)
          ary[i][j].sts = 1   # dead->living
        end
      else                    # living
        if (ary[i][j].adj <= 1) || (ary[i][j].adj >= 4)
          ary[i][j].sts = 0   # living->dead
        end
      end
    end
  end
end

=begin
field[33][27].sts = 1
field[33][28].sts = 1
field[33][29].sts = 1
field[34][27].sts = 1
field[35][28].sts = 1
=end

(1..M).each do |i|
  (1..N).each do |j|
    field[i][j].sts = [0,1].sample
  end
end


loop do
  print_screen(win, field)
  lifegame(field)
end

close_screen
