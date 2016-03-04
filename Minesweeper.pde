

import de.bezier.guido.*;
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++) {
        for(int j = 0; j < NUM_COLS; j++) {
            buttons[i][j] = new MSButton(i, j);
        }
    }

    
    
    setBombs(1);
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
    if(isWon())
        displayWinningMessage();
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
            if(bombs.contains(buttons[i][j]) && !buttons[i][j].isClicked())
                buttons[i][j].mousePressed();
        }
    }
}
public void displayWinningMessage()
{
    String wM = "You Win";
    // if(isWon())
    //     int temp = 0;
    //     for(int i = NUM_COLS/2 - temp; i < NUM_COLS/2 + temp; i++) {
    //         buttons[NUM_ROWS/2][i].setLabel(wM[temp]);
    //         temp++;
    //     }
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
    
    public void mousePressed () 
    {
        if(mouseButton == LEFT && marked == false)
            clicked = true;
        if(mouseButton == RIGHT && clicked == false)
            marked = !marked;
        else if(bombs.contains(this))
            displayLosingMessage();
        else if(countBombs(r,c) > 0) {
            if(marked == false)
                label = String.valueOf(countBombs(r,c));
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
    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

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
        if(isValid(row-1, col) && bombs.contains(buttons[row-1][col]))
            numBombs++;
        if(isValid(row, col-1) && bombs.contains(buttons[row][col-1]))
            numBombs++;
        if(isValid(row, col+1) && bombs.contains(buttons[row][col+1]))
            numBombs++;
        if(isValid(row+1, col) && bombs.contains(buttons[row+1][col]))
            numBombs++;
        if(isValid(row-1, col-1) && bombs.contains(buttons[row-1][col-1]))
            numBombs++;
        if(isValid(row+1, col+1) && bombs.contains(buttons[row+1][col+1]))
            numBombs++;
        if(isValid(row-1, col+1) && bombs.contains(buttons[row-1][col+1]))
            numBombs++;
        if(isValid(row+1, col-1) && bombs.contains(buttons[row+1][col-1]))
            numBombs++;
        return numBombs;
    }
}



