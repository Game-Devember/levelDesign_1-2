#pragma strict
var zombie :Transform;
var spawn1 :Transform;
var spawn2 :Transform;
var spawn3 :Transform;
function Start () {

InvokeRepeating("zombieSpawnage",0,2);

}

function Update () {


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
  