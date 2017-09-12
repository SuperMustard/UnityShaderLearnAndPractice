using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class myBloom : MonoBehaviour {

    #region Variables
    public Shader curShader;
    public int iterations = 1;
    public float blurSpeed = 0.6f;
    public int downsample = 2;
    [Range(0.0f, 4.0f)]
    public float luminanceThreshold = 0.6f;
    private Material curMaterial;
    #endregion

    #region Properties
    Material material
    {
        get
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return curMaterial;
        }
    }
    #endregion

    // Use this for initialization
    void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if (!curShader && !curShader.isSupported)
        {
            enabled = false;
        }
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetFloat("_LuminanceThreshold", luminanceThreshold);

            int rtW = src.width / downsample;
            int rtH = src.height / downsample;

            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
            RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
            buffer0.filterMode = FilterMode.Bilinear;

            Graphics.Blit(src, buffer0, material, 0); //提取亮处的pass
            for (int i = 0; i < iterations; i++)
            {
                material.SetFloat("_BlurSize", 1.0f + i * blurSpeed);

                Graphics.Blit(buffer0, buffer1, material, 1); //高斯模糊
                RenderTexture temp = buffer0; //switch render texture
                buffer0 = buffer1;
                buffer1 = temp;
            }

            material.SetTexture("_Bloom", buffer0);
            Graphics.Blit(src, dest, material, 2); //混合 (src 对应_MainTex)

            RenderTexture.ReleaseTemporary(buffer0);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnDisable()
    {
        if (curMaterial)
        {
            DestroyImmediate(curMaterial);
        }
    }
}
