#pragma strict
var zombie : Transform;
function Start () {
 spawnFunc();
}

function Update () {

}

function spawnFunc()
 {
   Instantiate(zombie,transform.position,Quaternion.identity);
  }