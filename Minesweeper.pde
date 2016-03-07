import de.bezier.guido.*;
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    colorMode(HSB, 100);
    Interactive.make( this );  // make the manager
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++) {
        for(int j = 0; j < NUM_COLS; j++) {
            buttons[i][j] = new MSButton(i, j);
        }
    }
    setBombs(25);
}
public void setBombs(int mines)
{
    int rB;
    int cB;
    for(int i = 0; i < mines; i++) {
        rB = (int)(Math.random()*NUM_ROWS);
        cB = (int)(Math.random()*NUM_COLS);
        if(!bombs.contains(buttons[rB][cB]))
            bombs.add(buttons[rB][cB]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() && gameOver == false) {
        displayMessage("You Won!", NUM_ROWS/2);
        gameOver = true;
    }        
    if(gameOver == true) {
        if(keyPressed && key == 'r') {
            restart();
        }
    }
}
public void restart()
{
    gameOver = false;
    bombs.clear();
    for(int i = 0; i < NUM_ROWS; i++) {
        for(int j = 0; j < NUM_COLS; j++) {
            buttons[i][j].reset();
        }
    }
    setBombs(25); 
}
public boolean isWon()
{
    for(int i = 0; i < NUM_ROWS; i++) {
        for(int j = 0; j < NUM_COLS; j++) {
            if(!bombs.contains(buttons[i][j]) && !buttons[i][j].isClicked())
                return false;
        }
    }
    return true;
}
public void displayLosingMessage()
{
    for(int i = 0; i < NUM_ROWS; i++) {
        for(int j = 0; j < NUM_COLS; j++) {
            buttons[i][j].unMark();
            buttons[i][j].setLabel("");
            if(!buttons[i][j].isClicked())
                buttons[i][j].mousePressed();
        }
        displayMessage("You Lose", i);
    }
    gameOver = true;
}
public void displayMessage(String str, int row)
{
    int index = 0;
    for(int i = NUM_COLS/2 - str.length()/2; i < NUM_COLS/2 + str.length()/2; i++) {
        buttons[row][i].setLabel(str.substring(index, index + 1));
        index++;
    }
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    public void mousePressed() 
    {
        if(gameOver == false) {
            if(mouseButton == LEFT && marked == false)
                clicked = true;
            if(mouseButton == RIGHT && clicked == false)
                marked = !marked;
            else if(bombs.contains(this) && marked == false)
                displayLosingMessage();
            else if(countBombs(r,c) > 0) {
                if(marked == false && gameOver == false)
                    label = "" + countBombs(r,c);
            }
            else {
                for(int i = -1; i < 2; i++) {
                    for(int j = -1; j < 2; j++) {
                        if(isValid(r+i, c+j) && !buttons[r+i][c+j].clicked)
                            buttons[r+i][c+j].mousePressed();
                    }
                }
            }
        }
    }
    public void draw () 
    {    
        if (marked)
            fill(0);
        else if(clicked && bombs.contains(this)) 
            fill(0,70,90);
        else if(clicked)
            fill(0, 0, 90);
        else 
            fill(0, 0, 60);
        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r < 0 || r >= NUM_ROWS || c < 0 || c >= NUM_COLS)
            return false;
        return true;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int i = -1; i < 2; i++) {
              for(int j = -1; j < 2; j++) {
                  if(isValid(row+i, col+j) && bombs.contains(buttons[row+i][col+j]))
                      numBombs++;
              }
        }
        return numBombs;
    }
    public void reset()
    {
        clicked = false;
        marked = false;
        label = "";
    }
    public void unMark()
    {
      marked = false;
    }
}
