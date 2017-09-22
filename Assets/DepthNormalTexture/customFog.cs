using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class customFog : MonoBehaviour {

    public Shader fogShader;
    private Material fogMaterial = null;
    private Camera myCamera;
    private Transform myTransform;

    [Range(0.0f, 3.0f)]
    public float fogDensity = 1.0f;

    public Color fogColor = Color.white;

    public float fogStart = 0.0f;
    public float fogEnd = 2.0f;

    new Camera camera
    {
        get
        {
            if (myCamera == null)
            {
                myCamera = GetComponent<Camera>();
            }
            return myCamera;
        }
    }

    public Transform cameraTransform {
        get {
            if (myTransform == null) {
                myTransform = camera.transform;
            }

            return myTransform;
        }
    }

    // Use this for initialization
    void Start()
    {
        fogMaterial = new Material(fogShader);
        //showDepthMaterial.hideFlags = HideFlags.HideAndDontSave;
    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnEnable()
    {
        camera.depthTextureMode |= DepthTextureMode.Depth;
        //camera.depthTextureMode |= DepthTextureMode.DepthNormals;
    }

    //添加这个实现后才会启用Material
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (fogMaterial != null)
        {
            Matrix4x4 frustumCorners = Matrix4x4.identity;

            float fov = camera.fieldOfView;
            float near = camera.nearClipPlane;
            float far = camera.farClipPlane;
            float aspect = camera.aspect;

            float halfHeight = near * Mathf.Tan(fov * 0.5f * Mathf.Deg2Rad);
            Vector3 toRight = cameraTransform.right * halfHeight * aspect;
            Vector3 toTop = cameraTransform.up * halfHeight;

            Vector3 topLeft = cameraTransform.forward * near + toTop - toRight;
            float scale = topLeft.magnitude / near;
            topLeft.Normalize();
            topLeft *= scale;

            Vector3 topRight = cameraTransform.forward * near + toRight + toTop;
            topRight.Normalize();
            topRight *= scale;

            Vector3 bottomLeft = cameraTransform.forward * near - toTop - toRight;
            bottomLeft.Normalize();
            bottomLeft *= scale;

            Vector3 bottomRight = cameraTransform.forward * near + toRight - toTop;
            bottomRight.Normalize();
            bottomRight *= scale;

            frustumCorners.SetRow(0, bottomLeft);
            frustumCorners.SetRow(1, bottomRight);
            frustumCorners.SetRow(2, topRight);
            frustumCorners.SetRow(3, topLeft);

            fogMaterial.SetMatrix("_FrustumCornersRay", frustumCorners);
            fogMaterial.SetMatrix("_ViewProjectionInverseMatrix", (camera.projectionMatrix * camera.worldToCameraMatrix).inverse);

            fogMaterial.SetFloat("_FogDensity", fogDensity);
            fogMaterial.SetColor("_FogColor", fogColor);
            fogMaterial.SetFloat("_FogStart", fogStart);
            fogMaterial.SetFloat("_FogEnd", fogEnd);

            Graphics.Blit(src, dest, fogMaterial);
        }
        else {
            Graphics.Blit(src, dest, fogMaterial);
        }
    }
}
