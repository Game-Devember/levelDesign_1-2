using UnityEngine;
using System.Collections;

public class playerController : MonoBehaviour {

	public float movementSpeed = 10;
	public float turningSpeed = 60;
	
	void FixedUpdate() {
		float horizontal = Input.GetAxis("Horizontal") * turningSpeed * Time.deltaTime;

		
		float vertical = Input.GetAxis("Vertical") * movementSpeed * Time.deltaTime;
		transform.TransformDirection(0, 0, vertical);
	}

}
