with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

with Ada.Task_Identification;  
use Ada.Task_Identification;

procedure Topup is

    protected Phone_Account is
        procedure Make_Call (Cost : in Integer);
        procedure Top_Up (Amount : in Integer);
        entry Wait_Until_Nearly_Empty;
    private
        Credit : Integer;
    end Phone_Account;

    protected body Phone_Account is

        procedure Make_Call (Cost : in Integer) is
        begin
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
            Put("Top_Up "); Put(Amount); Put(": "); 
            Put(Credit); Put(" -> "); Put(New_Credit);
            Put_Line("");
            Credit := New_Credit;
        end Top_Up;

        entry Wait_Until_Nearly_Empty when Credit <= 5 is 
        begin
            Null;
        end Wait_Until_Nearly_Empty;
    end Phone_Account;

    task Topping_Up;

    task body Topping_Up is
    begin
       loop
          Phone_Account.Wait_Until_Nearly_Empty;
          Phone_Account.Top_Up(10);
       end loop;
    end Topping_Up;

    task Making_Calls;

    task body Making_Calls is
       Cost : Integer := 1;
    begin
       loop
          Phone_Account.Make_Call(Cost);
          delay 1.0;
          Cost := Cost + 1;
       end loop;
    end Making_Calls;

begin
    Null;
end Topup;
