-module(types).

-export_type

-type Emp:: {Id::string(),Wage::integer()} | {Id::integer(),Gender::boolean()}.
-spec doSomething(fun(A)->B,[A],fun(A)->boolean())->Count when
    Count::integer().

-spec something(Worker,Data)->Wage| Daily when
   Worker::string(),
   Data::atom(),
   Wage::{amount,Value},
   Value::integer()|float(),
   Daily::Value.