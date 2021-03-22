
// a leaf node of an expression, containing an integer
class ArithExpDouble extends ArithExp
{
    public double value;

    public ArithExpDouble(double value)
    {
        this.value = value;
    }

    public int countNodes()
    {
        return 1;
    }

    @Override
    public void countNodesInOut(IntHolder resultInOut) {
        int result = resultInOut.value; // copy-in
        result += 1;
        resultInOut.value = result; // copy-out
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
        value = value + 1;
    }

    public String toString()
    {
        return "" + value;
    }
}
