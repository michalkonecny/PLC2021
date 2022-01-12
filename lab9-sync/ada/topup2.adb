with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

with Ada.Task_Identification;  
use Ada.Task_Identification;

procedure Topup2 is

    protected type Phone_Account is
        procedure Set_Name(new_name : String);
        procedure Make_Call (Cost : in Integer);
        procedure Top_Up (Amount : in Integer);
        entry Wait_Until_Nearly_Empty;
    private
        Credit : Integer := 0;
        Name : String(1..10) := "          ";
    end Phone_Account;

    protected body Phone_Account is
        procedure Set_Name(new_name : String) is
        begin
            Name := new_name;
        end Set_name;

        procedure Make_Call (Cost : in Integer) is
        begin
            Put(Name);
            if Credit >= Cost then
                Credit := Credit - Cost;
                Put("Made call costing ");
            else
                Put("Failed to make call costing ");
            end if;
            Put(Cost);
            Put_Line("");
        end Make_Call;

        procedure Top_Up (Amount : in Integer) is
            New_Credit : Integer := Credit + Amount;
        begin
            Put(Name);
            Put("Top_Up "); Put(Amount); Put(": "); Put(Credit); Put(" -> "); Put(New_Credit);
            Put_Line("");
            Credit := New_Credit;
        end Top_Up;

        entry Wait_Until_Nearly_Empty when Credit < 5 is 
        begin
            Null;
        end Wait_Until_Nearly_Empty;
    end Phone_Account;

    task type Topping_Up is
        entry Start(Account : Phone_Account);
    end Topping_Up;

    task body Topping_Up is
        My_Account : Access Phone_Account;
    begin
        accept Start(Account : Access Phone_Account) do
            My_Account := Account;
        end Start;
        loop
            My_Account.Wait_Until_Nearly_Empty;
            My_Account.Top_Up(10);
        end loop;
    end Topping_Up;

    task Making_Calls is
        entry Start(Account : Phone_Account);
    end Making_Calls;

    task body Making_Calls is
        Cost : Integer := 1;
        My_Account : Phone_Account;
    begin
        accept Start(Account : Phone_Account) do
            My_Account := Account;
        end Start;
        loop
            My_Account.Make_Call(Cost);
            delay 1.0;
            Cost := Cost + 1;
        end loop;
    end Making_Calls;
    
    Acc1, Acc2 : Phone_Account;

begin
    Acc1.Set_Name("Account 1 ");
    Acc2.Set_Name("Account 2 ");
    Null;
end Topup2;
