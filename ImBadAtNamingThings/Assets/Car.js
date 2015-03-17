#pragma strict
var carEntry:Transform;
var carCamera :Transform;
function Start () {
rigidbody.centerOfMass=new Vector3(0,0,25);


}

function Update () {

}
function OnTriggerEnter(other : Collider)
  {
   if(other.gameObject.tag == ("Car"))
    {
     Destroy(other.gameObject);
     carCamera.active = true;
     carEntry.active = true;
     carCamera.active = true;
     gameObject.active= false;
     
    }
   }
     