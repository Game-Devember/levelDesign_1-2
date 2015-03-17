//CarController1.js
var fr : Transform;
var rb : Transform;
var fl : Transform;
var lb : Transform; 
var enginePower=150.0;
 
var power=0.0;
var brake=0.0;
var steer=0.0;
var ebrake=0.002; 
var maxSteer=20.0;
 
function Start(){
    rigidbody.centerOfMass=Vector3(0,0,0.6);
}
 
function Update () {
    power=Input.GetAxis("Vertical") * enginePower * Time.deltaTime * 100.0;
    steer=Input.GetAxis("Horizontal") * maxSteer;
    brake=Input.GetKey("space") ? rigidbody.mass * ebrake: 0.0;
   
    GetCollider(0).steerAngle=steer;
    GetCollider(2).steerAngle=steer;
   
    if(brake > 0.0){
        GetCollider(0).brakeTorque=brake;
        GetCollider(1).brakeTorque=brake;
        GetCollider(2).brakeTorque=brake;
        GetCollider(3).brakeTorque=brake;
        GetCollider(0).motorTorque=0.0;
        GetCollider(2).motorTorque=0.0;
    } else {
        GetCollider(0).brakeTorque=0;
        GetCollider(1).brakeTorque=0;
        GetCollider(2).brakeTorque=0;
        GetCollider(3).brakeTorque=0;
        GetCollider(0).motorTorque=power;
        GetCollider(2).motorTorque=power;
    }
}
 
function GetCollider(n : int) : WheelCollider{
    if(n==0)
    return fr.GetComponent(WheelCollider);
    if(n==1)
    return rb.GetComponent(WheelCollider);
    if(n==2)
    return fl.GetComponent(WheelCollider);
    if(n==3)
    return lb.GetComponent(WheelCollider);
}
 