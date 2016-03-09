import de.bezier.guido.*;
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;
private int NUM_BOMBS = 10;
private int bHue = 0;
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
    setBombs(NUM_BOMBS);
}
public void setBombs(int mines)
{
    int rB;
    int cB;
    while(bombs.size() < mines) {
        rB = (int)(Math.random()*NUM_ROWS);
        cB = (int)(Math.random()*NUM_COLS);
        if(!bombs.contains(buttons[rB][cB]))
            bombs.add(buttons[rB][cB]);
    }
}

public void draw ()
{
    background(0);
    if(isWon() && gameOver == false) {
        gameOver = true;
        bHue = 60;
        for(int i = 0; i < NUM_ROWS; i++) {
            for(int j = 0; j < NUM_COLS; j++) {
                buttons[i][j].game();
            }
        }
        NUM_BOMBS += 10;
        if(NUM_BOMBS >= 400) {
            displayMessage("THANKS", NUM_ROWS/2 - 1);
            displayMessage("FOR", NUM_ROWS/2);
            displayMessage("PLAYING!", NUM_ROWS/2 + 1);
        } else {
            displayMessage("YOU WON!", NUM_ROWS/2 - 1);
            displayMessage("PRESS R TO RESTART", NUM_ROWS/2);
            displayMessage("MORE BOMBS THIS TIME", NUM_ROWS/2 + 1);
        }
    }        
    if(gameOver == true && NUM_BOMBS < 400 && keyPressed) {
        if(key == 'r')
            restart();
        if(key == 'p')
            NUM_BOMBS = 399;
        if(key == 'i')
            NUM_BOMBS = 20;
    }
}
public void restart()
{
    gameOver = false;
    bHue = 0;
    bombs.clear();
    for(int i = 0; i < NUM_ROWS; i++) {
        for(int j = 0; j < NUM_COLS; j++) {
            buttons[i][j].reset();
        }
    }
    setBombs(NUM_BOMBS); 
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
            buttons[i][j].game();
        }
        if(i == NUM_ROWS/2 - 1)
            displayMessage("GAME OVER!", i);
        else if(i == NUM_ROWS/2)
            displayMessage("PRESS R TO TRY AGAIN", i);
        else
            displayMessage("YOU LOSE", i);
    }
    gameOver = true;
}
public void displayMessage(String str, int row)
{
    int index = 0;
    String sH = str.substring(str.length()/2);
    for(int i = NUM_COLS/2 - str.length()/2; i < NUM_COLS/2 + sH.length(); i++) {
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
            fill(bHue,70,90);
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
    public void game()
    {
        marked = false;
        clicked = true;
        label = "";
    }
}
