r = 0.5;
h = 2.0;
lc = 0.25;
n_layers = 10;

Point(1) = {0.0, 0.0, 0.0, lc};
Point(2) = {r, 0.0, 0.0, lc};
Point(3) = {0.0, r, 0.0, lc};
Point(4) = {-r, 0.0, 0.0, lc};
Point(5) = {0.0, -r, 0.0, lc};

Circle(1) = {2, 1, 3};
Circle(2) = {3, 1, 4};
Circle(3) = {4, 1, 5};
Circle(4) = {5, 1, 2};

Line Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};

Extrude {0.0, 0.0, h} {
  Surface{1};
  Layers{n_layers};
  Recombine;
}

Physical Volume(0) = {1};
Physical Surface('outer') = {13, 17, 21, 25};
Physical Surface('top') = {26};
Physical Surface('bottom') = {1};
Physical Point('no_disp_x') = {3, 5, 8, 18};
Physical Point('no_disp_y') = {2, 4, 6, 13};