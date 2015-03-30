#pragma strict

var zombie :Transform;
var spawn :Transform[];
var timeSpan :float;
var timeInterval :float;
var player :Transform;
var passed : boolean;
var random :float;
var triggerRange :float;
var counter : float;
var trig : boolean;

function Start () 
{   
  
	passed=false;
	trig = false;
	counter = (timeSpan/timeInterval);
	timeFunc();
}
function Update ()
{
 	if(Vector3.Distance(transform.position,player.position)<10 && passed==false)
  	{
   		trig = true;
  	}
}
function spawnSystem()
{
  	random=Random.Range(0,3);
  	Instantiate(zombie,spawn[random].position , Quaternion.identity);
}
//YOU'RE FUCKING WELCOME
function timeFunc()
{
	if(trig && counter > 0)
  	{
   		spawnSystem();
   	    counter--;
  	}
  	Invoke("timeFunc",timeInterval);
}
