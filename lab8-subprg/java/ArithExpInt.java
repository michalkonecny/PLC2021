
// a leaf node of an expression, containing an integer
class ArithExpInt extends ArithExp
{
    public int value;

    public ArithExpInt(int value)
    {
        this.value = value;
    }

    public int countNodes()
    {
        return 1;
    }

    @Override
    public void countNodesInOut(IntHolder resultInOut) {
        IntHolder result = new IntHolder();
        result.value = resultInOut.value; // copy-in
        result.value += 1;
        resultInOut.value = result.value; // copy-out
    }

    @Override
    public void countNodesRef(IntHolder result) {
        result.value += 1;        
    }    

    public double getValue()
    {
        return value;
    }

    public void incrementAllNumbers()
    {
        value ++;
    }

    public String toString()
    {
        return "" + value;
    }


}
