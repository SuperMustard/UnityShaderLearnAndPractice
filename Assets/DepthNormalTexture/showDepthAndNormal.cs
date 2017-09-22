using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class showDepthAndNormal : MonoBehaviour
{
    public Shader showDepthShader;
    private Material showDepthMaterial = null;
    private Camera myCamera;


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



    // Use this for initialization
    void Start()
    {
        showDepthMaterial = new Material(showDepthShader);
        //showDepthMaterial.hideFlags = HideFlags.HideAndDontSave;
    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnEnable()
    {
        camera.depthTextureMode |= DepthTextureMode.Depth;
        camera.depthTextureMode |= DepthTextureMode.DepthNormals;
    }

    //添加这个实现后才会启用Material
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (showDepthMaterial != null)
        {
            Graphics.Blit(src, dest, showDepthMaterial);
        }
    }
}
