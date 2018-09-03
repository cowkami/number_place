import os, times
from strutils import parseInt, intToStr
from math import ceil

type
  col = array[1..9, int]
  mtx = array[1..9, col]

proc viewMatrix(matrix: mtx) =
  for i in 1..9:
    for j in 1..9:
      stdout.write intToStr(matrix[i][j]), " "
    stdout.write "\n"

proc checkNum(matrix: mtx, row: int, col: int, num: int): bool =
  # check whether same number is on same columns or not.
  for i in 1..9:
    if matrix[i][col] == num:
      return false

  # check whether same number is on same rows or not.
  for i in 1..9:
    if matrix[row][i] == num:
      return false
  # check whether same number is on same area or not.
  var area_x, area_y: int
  area_x = 3 * (ceil(col / 3) - 1).int
  area_y = 3 * (ceil(row / 3) - 1).int

  for i in 1..3:
    for j in 1..3:
      if matrix[i + area_y][j + area_x] == num:
        return false
  true

# Depth-First Search
proc recursiveDFS(m: mtx, row: int, col: int): mtx =
  var
    nextrow:int
    nextcol:int
  # when row is 10, search hsa finished.
  if row == 10:
    viewMatrix(m)
    return m
  # when col is 9, go next row
  elif col == 9:
    nextrow = row + 1
    nextcol = 1
  else:
    nextrow = row
    nextcol = col + 1

  if m[row][col] != 0:
    return recursiveDFS(m, nextrow, nextcol)
  else:
    for i in 1..9:
      if checkNum(m, row, col, i):
        var matrix = m
        matrix[row][col] = i
        var matrix0 = recursiveDFS(matrix, nextrow, nextcol)
        if matrix0 != matrix:
          return matrix0
    return m

proc solve(m: mtx): mtx =
  # first, record numbers may be in the cell to each cells.
  m

block main:
  var f: File = open("numbers.txt", FileMode.fmRead)
  defer:
    close(f)
    echo "finish !"

  var sudoku: mtx
  for i in 1..9:
    var line = f.readLine()
    for j in 1..9:
      sudoku[i][j] = int(line[j - 1]) - int('0')

  # solve Sudoku !
  var ans = recursiveDFS(sudoku, 1, 1)
