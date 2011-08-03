// adapted from Reas & Fry, 'Processing' p466
// shows cell 'birth' graphically by animating the alpha channel

int [][] grid, futureGrid;
color myIso = color(50, 50, 90); // #32325A
color myOvr = color(120, 100, 80); // #786450
color myBth = color(160, 254, 140); // #A0FE8C

void setup() {
  size(540, 320);
  frameRate(50);
  grid = new int[width][height];
  futureGrid = new int[width][height];
  float density = 0.3 * width * height;
  for (int i = 0; i < density; i++) {
    grid[int(random(width))][int(random(height))] = 1;
  }
  background(0);
}

void draw() {
  for (int x = 1; x < width-1; x++) {
    for (int y = 1; y < height-1; y++) {
      int nb = neighbors(x, y); //check number of neighbors
      if ((grid[x][y] == 1) && (nb < 2)) {
        changeColor(x, y, 0, myIso); // isolation death
      }
      else if ((grid[x][y] == 1) && (nb > 3)) {
        changeColor(x, y, 0, myOvr); // overpopulation death
      }
      else if ((grid[x][y] == 0) && (nb == 3)) {
        changeColor(x, y, 1, myBth); // birth (fade in green)
      }
      else {
        futureGrid[x][y] = grid[x][y]; // survive (stay green)
      }
    }
  }
 // swaps current and future grids
  int[][] temp = grid;
  grid = futureGrid;
  futureGrid = temp;
}

// counts no. of 'live' adjacent cells
int neighbors(int x, int y) {
  return grid[x][y-1] + // North
         grid[x+1][y-1] + // NorthEast
         grid[x+1][y] + // East
         grid[x+1][y+1] + // SouthEast
         grid[x][y+1] + // South
         grid[x-1][y+1] + // SouthWest
         grid[x-1][y] + // West
         grid[x-1][y-1]; // NorthWest
}

// changes colours on death or birth
void changeColor(int x, int y, int grid, color newColor) {
  futureGrid[x][y] = grid;

// highlights births
  if (grid == 0) {
    int newAlpha = 10; // increase up to 255 for no alpha fade
    color fadeColor = (newColor & 0xffffff) | (newAlpha << 24); 
    set (x, y, fadeColor);
  }
  else {
    set (x, y, newColor);
  }
// comment out 'highlights births' above and uncomment below to fade out all but survivors:
//  int newAlpha = 10;
//  color fadeColor = (newColor & 0xffffff) | (newAlpha << 24); 
//  set (x, y, fadeColor);
}

