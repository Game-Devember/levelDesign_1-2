using UnityEngine;
using System.Collections;

public class cameraController : MonoBehaviour {
	public double tm = 2.0;
	public double t;
	public GameObject target;
	public float damping = 0;
	Vector3 offset;
	
	void Start() {
		offset = transform.position - target.transform.position;
		t = Time.time;

	}
	
	void FixedUpdate() {
		if (Time.time > t + tm)
						damping = 4f;
		Vector3 desiredPosition = target.transform.position + offset;
		Vector3 position = Vector3.Lerp(transform.position, desiredPosition, Time.deltaTime * damping);
		transform.position = position;
		
		transform.LookAt(target.transform.position);
	}
}

  