// System Verilog Queues  
// Reference: https://www.chipverify.com/systemverilog/systemverilog-queues
// SV queue: FIFO scheme that stores the same data types. 
// They can be Indexed 
// They can be Concatanated. 
// They can be sliced.
// They can be passed to the tasks/functions. 



module day46();
  
  string       Operations[$];  // A queue of string elements 
  bit [3:0]    Numbers[8];     // A queue of 4-bit bit elements 
  
  
  logic [7:0]  elements[$:127];  // Queue of 8-bit logic elements with maximum 128 slots. 
  
  initial begin
  // INITIALIZE QUEUE 
     int q1[$] = {1,2,3,4,5};  // Integer queue, initialize elements 
     int q2[$];  // Empty integer queue 
     int temp;   // Integer Variable 
  
  // INDEX QUEUE 
     temp = q1[0];   // Get the value at index 0 and store it into the temp
     temp = q1[$];   // Get the last item of the q1 and store it into the temp 
  
  // COPY/DELETE QUEUE 
     q2 = q1;        // Copy all the elements in q1 into q2 
     q1 = {};        // Empty the queue (delete all the items)
  
  
  // UPDATE QUEUE 
     q2[2] = 15;       // Replace element at index 2 of q2 with 15 
     q2.insert (2,15); // Insert value 15 to the index 2. 
  
  // APPEND Item to the QUEUE 
     q2 = {q2,15};    // Append 15 to the queue q2 
     q2 = {99,q2};    // Put 99 as the first element of the q2  
     q2 = q2[1:$];    // Delete the first item 
     q2 = q2[0:$-1];  // Delete Last Item 
     q2 = q2[1:$-1];  // Delete first and Last Item 
  end 
  
  // PRINT THE ELEMENTS OF A QUEUE 
  string op_list[$] = {"ADD","SUB","XOR","AND"};
  
  initial begin
    // PRINT THE ELEMENTS USING LOOP 
    foreach (op_list[i])
      $display("Operation[%0d]: %s ",i,op_list[i]);
    
    
    $display("The operation queue: %p",op_list);
    
   
    // SLICING THE QUEUE 
    $display("The First Operation: %s",op_list[0] );
    $display("The Last Operation: %s",op_list[$] );
    $display("First Two Operations: %p",op_list[0:1]);
    
    
    // ADD ELEMENT TO THE END OF THE QUEUE 
    op_list[$+1] = "OR";
    $display("The operation queue: %p",op_list);
    
    
    // DELETE ALL THE ITEMS IN THE OPERATION LIST 
    op_list = {};
    $display("The deleted operation queue: %p", op_list);

   
    $display("Queue Methods");
    
    $display("1-function size(): Returns the number of items in the queue");
        $display("Size of the op_list queue: %d",op_list.size());
    
    $display("2-function insert(input integer index, input element_t item);: Insert the given item at the specified index position");
    op_list.insert(0,"ADD");    
    op_list.insert(1,"OR");  
    op_list.insert(2,"XOR");
    op_list.insert(3,"AND");
    $display("The queue after the insert:%p",op_list);
    
    $display("3-function void delete ([input integer index]);: Deletes the elements at the specified index, and if not provided all the elements will be deleted");
    op_list.delete(2); // delete the index 2 
    $display("The queue after the delete:%p",op_list);
    
    $display("4-function element_t pop_front(): Removes and returns the first element of the queue ");
    $display("Pop_front:%s ",op_list.pop_front() );
    $display("The queue after the pop_front:%p",op_list);
    
    $display("5-function element_t pop_back(): Removes and returns the last element of the queue");
    $display("Pop_back:%s ",op_list.pop_back() );
    $display("The queue after the pop_back:%p",op_list);    
    
    $display("6-function void push_front(input element_t item): Insert the given element at the front of the queue");
    op_list.push_front("SLL");
    $display("The queue after the push_front(SLL):%p",op_list);   
    
    $display("7-function void push_back(input element_t item);: Insert the given element at the end of the queue");
    op_list.push_back("SUB");
    $display("The queue after the push_back(SUB):%p",op_list);       
  end 
  
endmodule 



