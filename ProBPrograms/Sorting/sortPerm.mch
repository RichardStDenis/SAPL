// Sorting an array of integer using the "perm" function
// from a suggestion of a referee, 2023
MACHINE Sorting
DEFINITIONS
  SET_PREF_MAX_INITIALISATIONS == 1;
  SET_PREF_MAX_OPERATIONS == 1;
  SET_PREF_MAXINT == 15;
  SET_PREF_MININT == -16;
  SET_PREF_TIME_OUT == 100000000;
  "LibraryIo.def"
CONSTANTS A, p, sortedA
PROPERTIES
  //A = [428, 475, 166, 247, 399] & 
  A = [323, 322, 15, 295, 23, 47, 38, 38, 136, 347, 95, 25, 432, 197, 97, 287, 401, 432, 223, 46] &
  p : perm(dom(A)) & sortedA = (p;A) &  !(x_).(x_:2..size(A) => !(y_).(y_:1..(x_-1) => sortedA(y_) < sortedA(x_)))
OPERATIONS
  DisplayArrays = BEGIN PRINT(A); PRINT(sortedA) END END