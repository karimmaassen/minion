	(function(){
	
	"use strict";

	minion.define("minion", {

		/**
		*
		* Yep pretty much exactly what it seems like it does
		* 
		*/

		Singleton : minion.extend("minion.Class", {

			// You can add static methods and properties to a non static class through __static...
			__static : {

				__isSingleton: true,
				
				getInstance : function(){
					if(!this.__instance){
						var This = this;
						this.__instance =  new This();
						return this.__instance;
					}
					return this.__instance;
				}
			},

			__preInit : function(){
				if(this.constructor.__instance){
					return this.constructor.__instance;
				}
				
				this.init.apply(this, arguments);

				this.constructor.__instance = this;
				return this.constructor.__instance;
			},

			init : function(){

			}

		})
	});
	
})();