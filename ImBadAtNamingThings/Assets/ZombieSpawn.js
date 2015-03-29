#pragma strict
var zombie :Transform;
var spawn1 :Transform;
var spawn2 :Transform;
var spawn3 :Transform;
var timeSpan :float;
var timeInterval :float;
var player :Transform;
var passed : boolean;
function Start () {
passed=false;
}
function Update () {
if(Vector3.Distance(player.position,transform.position)<10)
{
InvokeRepeating("zombieSpawnage",0,timeInterval);
spawnInterval();
gameObject.SetActive(false);
}

}
function  zombieSpawnage()
  {
  if ( Random.value > 0.3&&Random.value < 0.6)
{
Instantiate(zombie,spawn1.position, Quaternion.identity);
Debug.Log("spawn");
}
else
if ( Random.value > 0.6 && Random.value < 0.9)
{
Instantiate(zombie,spawn2.position, Quaternion.identity);
Debug.Log("spawn");

}
else
if ( Random.value < 0.3 )
{
Instantiate(zombie,spawn3.position , Quaternion.identity);
Debug.Log("spawn");
}
  }
 function spawnInterval()
   {
    yield WaitForSeconds(timeSpan);
    }
    
 function spawnSequence()
  {passed=true;
   
}