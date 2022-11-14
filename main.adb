with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
with Ada.Strings, Ada.Strings.Fixed, Ada.Strings.Unbounded.Text_IO;
use Ada.Strings.Unbounded, Ada.Strings.Fixed, Ada.Strings.Unbounded.Text_IO;
with Ada.Strings;              use Ada.Strings;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Streams;
with Ada.Float_Text_IO;

procedure main is

   -- instantiate blank string for filename
   --file_name : string := "scores.txt";  ~ comment and switch implementation below for hard coded file name
   file_name : string (1 .. 10) := (others => ' '); -- comment and switch here

   -- header information array
   type header is new string (1 .. 80);

   -- global variables
   ustr_buffer : unbounded_string;
   datafile, outfile  : file_type;


   -- buffers and max char counts
   BUFFER_INT     : integer  := 0;
   MAX_CHARS      : constant := 8;
   MAX_CLASS_SIZE : constant := 30;
   my_COUNT       : integer  := 1;


   -------------------------------------------------------------------------------
   -------------------------------------------------------------------------------
   -- Student record class
   type student is tagged record
      cnum                             : string (1 .. 8);
      cla, ola, quiz, exam, final_exam : integer;
   end record;
   type roster is array (positive range 1 .. 22) of student;


   -------------------------------------------------------------------------------
   type average is tagged record
      sum                                           : float   := 0.0;
      ola, cla, quiz, exam, final_exam, final_score : integer := 0;
   end record;
   type average_array is array (Positive range 1 .. 22) of average;


   -------------------------------------------------------------------------------
   type highest is record
      cla, ola, quiz, exam, final_exam : integer := 0;
   end record;

   -- instantiate arrays for storage
   a      : average_array;
   people : roster;
   h      : highest;


-----------------------------------------------------------------------------
   -- function to get file name
   function get_filename return String is
      line : String (1 .. 1_000);
      last : Natural;
   begin
      get_line(line, last);
      return line(1 .. last);
   end get_filename;


-------------------------------------------------------------------------------
   -- function to print user requested student cnum
   procedure printrequest is
      input : constant string := Ada.Text_IO.Get_Line;
   begin
      for index in people'range loop
         if (input = people(index).cnum) then
            put(people(index).cnum);
            put(' ');
            put(people(index).cla);
            put(' ');
            put(people(index).ola);
            put(' ');
            put(people(index).quiz);
            put(' ');
            put(people(index).exam);
            put(' ');
            put(people(index).final_exam);
            New_Line;
         end if;
      end loop;
   end printRequest;


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
   -- function checks student position in averages array and returns letter grade
   -- representation

   --    ~~ params ~~
   -------------------------------------
   --  integer index position for student

   --    ~~ return ~~
   -------------------------------------
   --  character representation of grade
-------------------------------------------------------------------------------
   procedure print_letter_grade (i :Integer) is
   begin
      if a(i).final_score >= 90 then
         put_line("A");
      end if;
      if a(i).final_score >= 87 and a(i).final_score < 90 then
         put_line("B");
      end if;
      if a(i).final_score >= 83 and a(i).final_score < 87 then
         put_line("B+");
      end if;
      if a(i).final_score >= 80 and a(i).final_score < 83 then
         put_line("B-");
      end if;
      if a(i).final_score >= 77 and a(i).final_score < 80 then
         put_line("C+");
      end if;
      if a(i).final_score < 77 then
         put_line("C");
      end if;
   end print_letter_grade;


   -------------------------------------------------------------------------------
   -------------------------------------------------------------------------------
   --  loop through all data in array and print to output
   -------------------------------------------------------------------------------
   -------------------------------------------------------------------------------
   procedure printdata is
   begin
      for index in people'range loop
         put(people(index).cnum);
         put(' ');
         put(people(index).cla);
         put(' ');
         put(people(index).ola);
         put(' ');
         put(people(index).quiz);
         put(' ');
         Put (people(index).exam);
         put(' ');
         put(people(index).final_exam);
         put("               ");
         --    call function to print grade
         print_Letter_Grade(index);
         New_Line;
      end loop;

   end printdata;

   -------------------------------------------------------------------------------
   -------------------------------------------------------------------------------
    -- function loop through all students and add score to final score sum
   -------------------------------------------------------------------------------
   procedure sum_scores is
   begin
      for i in people'range loop
         a(i).cla         := people(i).cla + a(i).cla;
         a(i).ola         := people(i).ola + a(i).ola;
         a(i).quiz        := people(i).quiz + a(i).quiz;
         a(i).exam        := people(i).exam + a(i).exam;
         a(i).final_exam  := people(i).final_exam + a(i).final_exam;
         -- final score is sum of all individual scores
         a(i).final_score :=
           a(i).cla + a(i).ola + a(i).quiz + a(i).exam + a(i).final_exam;
      end loop;
   end sum_scores;
   -------------------------------------------------------------------------------
   -------------------------------------------------------------------------------
     -- avg all columns for class averages
   -------------------------------------------------------------------------------
   -------------------------------------------------------------------------------
   function avg_test_score (i : integer) return float is
      sum     : float   := 0.0;
      count   : integer := 1;
      highest : integer := 0;
   begin
      -- for all students
      for index in integer range 1 .. 22 loop
         -- if passed column position equals column
         if i = 1 then
            -- add float conversion of score to sum
            sum   := float(people(index).cla) + sum;
            -- increase count of students
            count := count + 1;
            -- if index position is greater than last highest score
            if people(index).cla > h.cla then
               -- add new highest score
               h.cla := people (index).cla;
            end if;
            -- repeat if logic for all columns
         elsif i = 2 then
            sum   := float(people(index).ola) + sum;
            count := count + 1;
            if people(index).ola > h.ola then
               h.ola := people (index).ola;
            end if;
         elsif i = 3 then
            sum   := float(people(index).quiz) + sum;
            count := count + 1;
            if people(index).quiz > h.quiz then
               h.quiz := people (index).quiz;
            end if;
         elsif i = 4 then
            sum   := float(people(index).exam) + sum;
            count := count + 1;
            if people(index).exam > h.exam then
               h.exam := people (index).exam;
            end if;
         elsif i = 5 then
            sum   := float(people(index).final_exam) + sum;
            count := count + 1;
            if people(index).final_exam > h.final_exam then
               h.final_exam := people(index).final_exam;
            end if;
         end if;
      end loop;
      -- sum is total divided by float conversion of count
      sum := sum / float(count);
      return sum;
   end avg_test_score;


   -------------------------------------------------------------------------------
   -- simple procedure for returning header row
   -------------------------------------------------------------------------------
   procedure printheader is
   begin
      put(ustr_buffer);
      put("                                           ");
      put("Final Grade");
      New_Line;
   end printheader;


   -------------------------------------------------------------------------------
   -- simple procedure for returning footer row
   -------------------------------------------------------------------------------
   procedure printfooter is
   begin
      put("Average : ");
      put("        ");
      -- ada.Float_Text_IO is access control to put float in output
      -- float to string conversion
      Ada.Float_Text_IO.put(avg_test_score (1), 2, 1, 0);
      put("        ");
      Ada.Float_Text_IO.put(avg_test_score (2), 2, 1, 0);
      put("        ");
      Ada.Float_Text_IO.put(avg_test_score (3), 2, 1, 0);
      put("        ");
      Ada.Float_Text_IO.put(avg_test_score (4), 2, 1, 0);
      put("        ");
      Ada.Float_Text_IO.put(avg_test_score (5), 2, 1, 0);
      New_Line;
      put("Highest :");
      put(' ');
      put(h.cla);
      put(' ');
      put(h.ola);
      put(' ');
      put(h.quiz);
      put(' ');
      put(h.exam);
      put(' ');
      put(h.final_exam);
      New_Line;
   end printfooter;


   -------------------------------------------------------------------------------
   -- simple procedure for changing output and printing existing functions to outFile
   -------------------------------------------------------------------------------
   procedure printoutfile is
   begin
      -- set output to outfile
      Set_Output(outfile);
      -- call output functions and procedures
      printheader;
      printdata;
      put_line("----------------------------------------------");
      printfooter;

   end printoutfile;


-------------------------------------------------------------------------------
--------------------- BEGIN PROGRAM~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-------------------------------------------------------------------------------
begin
   --   prompt for filename
   put_line("----------------------------------------------------------------");

   put_line("----------------------------------------------------------------");
   put_line("What is the file name?");


   -- call getfilename function
   file_name := get_filename;
   put_line("----------------------------------------------------------------");

   -- open input file
   open (File => datafile, Mode => In_File, Name => file_name);
   -- create output file
   create (File => outfile, Mode => Out_File, Name => "results.txt");
   -- instantiate buffer
   ustr_buffer := Get_Line(datafile);
   -- set TEXT_IO input to line 2
   set_line (datafile, To => 2);
   begin
      while not End_Of_File(datafile) loop
         declare
            -- read in full line
            line : String := Get_Line(datafile);
         begin
            -- process line positions
            people (my_count).cnum       := line (1 .. 8);
            people (my_count).cla        := Integer'Value (line (9 .. 12));
            people (my_count).ola        := Integer'Value (line (13 .. 16));
            people (my_count).quiz       := Integer'Value (line (17 .. 20));
            people (my_count).exam       := Integer'Value (line (21 .. 23));
            people (my_count).final_exam := Integer'Value (line (24 .. 27));

            --New_Line;
            my_count := my_count + 1;
         end;
      end loop;
   end;

   -- call sum scores
   sum_scores;
   -- output formatting
   put("----------------------------------------------------------------");
   New_Line;


   -- for 2 cycles
   --       -- prompt user for student to return
   for index in Integer range 1 .. 2 loop
      put_line("----------------------------------------------------------------");
      put("Which student would you like to see?: ___  ");
      -- return information function
      printrequest;

   end loop;
   New_Line;
   Put_Line("-----------------------------------------------------------------------------------");
   Put_Line("-----------------------------------------------------------------------------------");
   Put_Line("-----------------------------------------------------------------------------------");
   printheader;
   printdata;
   printoutfile;
   Set_Output(Standard_Output);
   Put_Line("-----------------------------------------------------------------------------------");
   Put_Line("-----------------------------------------------------------------------------------");
   printfooter;
   Put_Line("-----------------------------------------------------------------------------------");
   Put_Line("-----------------------------------------------------------------------------------");
   Put_Line("-----------------                               -----------------------------------");
   Put_Line("---------------------        GOODBYE        ---------------------------------------");
   Put_Line("-------------------------                ------------------------------------------");
   Put_Line("-----------------------------------------------------------------------------------");
exception
   when End_Error =>
      if Is_Open (dataFile) then
         Close (dataFile);
      end if;
      if Is_Open(outFile) then
         Close (outFile);
      end if;
end main;
