f0xy.define("com.example", {

	Example2 : f0xy.extend("com.example.Example1", {

		test: 3,
		test2: 4,

		init: function(){
			
		},

		logSomething : function(something){
			this.__super(something);
		}

	})
});