#pragma strict
var speed =20.0;
var Bullet :Transform;
function Start () {

}

function Update () {
if(Input.GetMouseButtonDown(0))
 {
  Instantiate(Bullet,transform.position,transform.rotation);
  
 }

}