package com.example.sid2019.APP.Database;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class DatabaseHandler extends SQLiteOpenHelper {

    public static final int DATABASE_VERSION = 1;
    public static final String DATABASE_NAME = "sid.db";
    DataBaseConfig config = new DataBaseConfig();

    public DatabaseHandler(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
        sqLiteDatabase.execSQL(config.SQL_CREATE_CULTURA);
        sqLiteDatabase.execSQL(config.SQL_CREATE_MEDICOESTEMPERATURA);
        sqLiteDatabase.execSQL(config.SQL_CREATE_MEDICOESLUZ);
        sqLiteDatabase.execSQL(config.SQL_CREATE_ALERTASGLOBAIS);
        sqLiteDatabase.execSQL(config.SQL_CREATE_AVAILABLEIDS);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    public void insert_available_id(int idCultura){
        ContentValues values = new ContentValues();
        values.put(DataBaseConfig.AvailableIds.COLUMN_NAME_IDCULTURA,idCultura);
        getWritableDatabase().insert(DataBaseConfig.AvailableIds.TABLE_NAME,null,values);
    }

    public void insert_Cultura(int idCultura,String nomeCultura,String descricaoCultura){

        clearCultura();
        ContentValues values = new ContentValues();
        values.put(DataBaseConfig.Cultura.COLUMN_NAME_IDCULTURA,idCultura);
        values.put(DataBaseConfig.Cultura.COLUMN_NAME_NOMECULTURA,nomeCultura);
        values.put(DataBaseConfig.Cultura.COLUMN_NAME_DESCRICAOCULTURA,descricaoCultura);
        getWritableDatabase().insert(DataBaseConfig.Cultura.TABLE_NAME,null,values);
    }

    public void insert_MedicaoTemperatura(String dataHoraMedicao, double temperatura){

        ContentValues values = new ContentValues();
        values.put(DataBaseConfig.MedicoesTemperatura.COLUMN_NAME_DATAHORAMEDICAO,dataHoraMedicao);
        values.put(DataBaseConfig.MedicoesTemperatura.COLUMN_NAME_TEMPERATURA,temperatura);
        getWritableDatabase().insert(DataBaseConfig.MedicoesTemperatura.TABLE_NAME,null,values);
    }
    public void clearMedicoes(){
        getWritableDatabase().execSQL(config.SQL_DELETE_MEDICOESTEMPERATURA_DATA);
        getWritableDatabase().execSQL(config.SQL_DELETE_MEDICOESLUZ_DATA);
    }

    public void insert_MedicaoLuz(String dataHoraMedicao, double luz) {
        ContentValues values = new ContentValues();
        values.put(DataBaseConfig.MedicoesLuz.COLUMN_NAME_DATAHORAMEDICAO,dataHoraMedicao);
        values.put(DataBaseConfig.MedicoesLuz.COLUMN_NAME_LUZ,luz);
        getWritableDatabase().insert(DataBaseConfig.MedicoesLuz.TABLE_NAME,null,values);
    }

    public void insert_alertaGlobal(String dataHoraMedicao, String nomeVariavel, double limiteInferior, double limiteSuperior, double valorMedicao, String descricao) {
        ContentValues values = new ContentValues();
        values.put(DataBaseConfig.AlertasGlobais.COLUMN_NAME_DATAHORAMEDICAO,dataHoraMedicao);
        values.put(DataBaseConfig.AlertasGlobais.COLUMN_NAME_NOMEVARIAVEL,nomeVariavel);
        values.put(DataBaseConfig.AlertasGlobais.COLUMN_NAME_Limite_Inferior,limiteInferior);
        values.put(DataBaseConfig.AlertasGlobais.COLUMN_NAME_Limite_Superior,limiteSuperior);
        values.put(DataBaseConfig.AlertasGlobais.COLUMN_NAME_VALORMEDICAO,valorMedicao);
        values.put(DataBaseConfig.AlertasGlobais.COLUMN_NAME_DESCRICAO,descricao);
        getWritableDatabase().insert(DataBaseConfig.AlertasGlobais.TABLE_NAME,null,values);
    }

    public void clearAlertasGlobais() {
        getWritableDatabase().execSQL(config.SQL_DELETE_ALERTASGLOBAIS_DATA);
    }
    public void clearIds(){
        getWritableDatabase().execSQL(config.SQL_DELETE_AVAILABLEIDS);
    }
    public void clearCultura(){
        getWritableDatabase().execSQL(config.SQL_DELETE_CULTURA_DATA);
    }


}
